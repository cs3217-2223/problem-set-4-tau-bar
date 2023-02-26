import UIKit
import CoreData

class LevelBuilderViewController: UIViewController {
    // IBOutlets
    @IBOutlet var levelNameTextField: UITextField!
    @IBOutlet var boardView: UIView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var loadButton: UIButton!
    @IBOutlet var ballStepper: UIStepper!
    @IBOutlet var ballCountLabel: UILabel!
    @IBOutlet var gameModeSelect: UISegmentedControl!

    @IBOutlet var rotationLabel: UILabel!
    @IBOutlet var rotationSlider: UISlider!
    // Delegate references
    weak var actionsDelegate: LevelBuilderActionsDelegate?
    var selectedObject: BoardObjectWrapper? {
        didSet {
            if selectedObject == nil {
                rotationLabel.alpha = 0
                rotationSlider.alpha = 0
            } else {
                rotationLabel.alpha = 1
                rotationSlider.alpha = 1
            }

            guard let rotationValue = selectedObject?.object.rotation else { return }
            rotationSlider.value = Float(rotationValue)
        }
    }

    // Model objects
    var board: Board? {
        didSet {
            removeAllBoardObjectsFromView()
            loadObjectsFromModelOnBoard()
            setInputValues()
        }
    }

    // Data Manager
    let dataManager = DataManager()

    // Helper variables & properties
    var objectsToViews: [BoardObjectWrapper: BoardObjectView] = [:]
    var viewsToObjects: [BoardObjectView: BoardObjectWrapper] = [:]
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        boardView.setNeedsLayout()
        boardView.layoutIfNeeded()

        // Set up delegates
        guard let toolsViewController = self.children[0] as? ToolsViewController else { return }
        self.actionsDelegate = toolsViewController
        toolsViewController.delegate = self

        // Initialize empty board with current boardView size
        // if no board passed to controller
        if board == nil {
            board = createEmptyBoard()
        }

        // Register for relevant notifications
        NotificationCenter.default.addObserver(self, selector: #selector(addObjectToBoardView),
                                               name: .objectAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteObjectFromBoardView),
                                               name: .objectDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveObjectOnBoardView),
                                               name: .objectMoved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearBoardView),
                                               name: .boardCleared, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resizeObjectOnBoardView),
                                               name: .objectResizeSuccess, object: nil)

        // Do any additional setup after loading the view.
    }
    @IBAction func didRotateSelected(_ sender: Any) {
        guard let selectedObject = selectedObject else { return }
        let isRotated = board?.rotateObject(selectedObject, to: Double(rotationSlider.value))
        if isRotated ?? false {
            rotateSelected(to: Double(rotationSlider.value))
        } else {
            rotationSlider.value = Float(selectedObject.object.rotation)
        }
    }

    func rotateSelected(to rotation: Double) {
        guard let selectedObject = selectedObject else { return }
        guard let rotatedView = objectsToViews[selectedObject] else { return }
        rotatedView.layer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
    }

    // MARK: Functions for interactions with UI buttons
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: boardView)
        actionsDelegate?.didTapBoard(at: tapLocation)
    }

    /// Resets the level to be empty when the reset button is tapped.
    @IBAction func resetButtonTapped(_ sender: Any) {
        board?.removeAllObjects()
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToGameView", sender: self)
    }

    @IBAction func didChangeBallCount(_ sender: UIStepper) {
        let newBalls = Int(ballStepper.value)
        if newBalls >= LevelBuilderConstants.minBalls,
           newBalls <= LevelBuilderConstants.maxBalls {
            board?.balls = newBalls
            ballCountLabel.text = String(newBalls)
        }
    }

    /// Saves the level with the current level name.
    /// If no name is provided, the level is not saved.
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let board = board,
              let levelName = getLevelName() else { return }

        if levelName.isEmpty {
            alertUserNoName()
            return
        }

        board.name = levelName
        do {
            try dataManager.save(board: board)
            alertUserLevelSaved()
        } catch {
            print(error)
            alertUserSaveError()
        }
    }

    /// Opens the view showing the saved levels when the load button is tapped.
    @IBAction func loadButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToLevelSelect", sender: sender)
    }

    // MARK: Functions for segues & unwinding
    @IBAction func unwindFromGameViewController(_ segue: UIStoryboardSegue) {}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameView" {
            guard let gameVc = segue.destination as? GameViewController else { return }
            gameVc.fromDesigner = true
            gameVc.board = board
        } else if segue.identifier == "goToLevelSelect" {
            guard let levelSelectVc = segue.destination as? LevelSelectViewController else { return }
            levelSelectVc.dataManager = dataManager
            levelSelectVc.delegate = self
        }
    }

    @IBAction func didSelectGameMode(_ sender: Any) {
        let mode = LevelBuilderConstants.gameModes[gameModeSelect.selectedSegmentIndex]
        board?.gameMode = mode
    }
    // MARK: Functions for interacting with model
    func addObject(addedObjectWrapper: BoardObjectWrapper) {
        board?.addObject(addedObjectWrapper)
    }

    func deleteObject(of deletedView: BoardObjectView) {
        guard let deletedObjectWrapper = viewsToObjects[deletedView] else {
            return
        }

        board?.removeObject(deletedObjectWrapper)
    }

    func moveObject(of sender: UIPanGestureRecognizer) {
        guard let movedView = sender.view as? BoardObjectView,
              let movedObjectWrapper = viewsToObjects[movedView] else {
            return
        }

        let newLocation = sender.location(in: boardView)
        board?.moveObject(movedObjectWrapper, to: newLocation)
    }

    // MARK: Notification Functions
    /// Adds a peg to the board view when receive .objectAdded notification from board model.
    @objc func addObjectToBoardView(_ notification: Notification) {
        guard let newObjectWrapper = notification.object as? BoardObjectWrapper else {
            return
        }

        insertSubview(for: newObjectWrapper)
    }

    /// Deletes a peg from the board view when receive .objectDeleted notification from board model.
    @objc func deleteObjectFromBoardView(_ notification: Notification) {
        guard let deletedObjectWrapper = notification.object as? BoardObjectWrapper,
              let deletedView = objectsToViews[deletedObjectWrapper] else {
            return
        }

        deletedView.removeFromSuperview()
        objectsToViews.removeValue(forKey: deletedObjectWrapper)
        viewsToObjects.removeValue(forKey: deletedView)
    }

    /// Moves a peg on the board view when receive .objectMoved notification from board model.
    @objc func moveObjectOnBoardView(_ notification: Notification) {
        guard let movedObjectWrapper = notification.object as? BoardObjectWrapper else { return }

        let movedView = objectsToViews[movedObjectWrapper]
        movedView?.center.x = movedObjectWrapper.object.position.x
        movedView?.center.y = movedObjectWrapper.object.position.y
    }

    @objc func resizeObjectOnBoardView(_ notification: Notification) {
        guard let resizedObjectWrapper = notification.object as? BoardObjectWrapper else { return }

        let resizedView = objectsToViews[resizedObjectWrapper]
        var frame = resizedView?.frame
        frame?.size.height = resizedObjectWrapper.object.height
        frame?.size.width = resizedObjectWrapper.object.width
        guard let frame = frame else { return }
        // resizing not commutative with previous rotations, so reset rotation temporarily
        resizedView?.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1)

        resizedView?.frame = frame
        resizedView?.center.x = resizedObjectWrapper.object.position.x
        resizedView?.center.y = resizedObjectWrapper.object.position.y

        // reset rotation afterwards
        let rotationValue = resizedObjectWrapper.object.rotation
        resizedView?.layer.transform = CATransform3DMakeRotation(rotationValue, 0, 0, 1)
    }

    /// Clears board view when receive .boardCleared notification from board model.
    @objc func clearBoardView(_ notification: Notification) {
        removeAllBoardObjectsFromView()
    }

    @objc func notifyUserSaved() {
        alertUserLevelSaved()
    }

    @objc func notifyUserSaveError() {
        alertUserSaveError()
    }

    // MARK: Helper functions
    private func setInputValues() {
        guard let balls = board?.balls, let gameMode = board?.gameMode else { return }
        ballStepper.value = Double(balls)
        ballCountLabel.text = String(balls)
        gameModeSelect.selectedSegmentIndex = LevelBuilderConstants.gameModes.firstIndex(of: gameMode) ?? 0
        setTextFieldText(to: board?.name ?? Board.defaultBoardName)
    }

    func createEmptyBoard() -> Board {
        Board(width: boardView.frame.width, height: boardView.frame.height)
    }

    /// Sets a new text to the level name text field.
    private func setTextFieldText(to newName: String) {
        levelNameTextField.text = newName
    }

    /// Returns the text currently in the level name text field.
    private func getLevelName() -> String? {
        levelNameTextField.text
    }

    private func loadObjectsFromModelOnBoard() {
        board?.objects.forEach({
            insertSubview(for: $0)
        })
    }

    private func createBoardObjectView(with addedObject: BoardObject, at tapLocation: CGPoint) -> BoardObjectView? {
        let height = addedObject.height
        let width = addedObject.width
        let newObjectView = BoardObjectView(image: UIImage(named: addedObject.asset))
        newObjectView.frame = CGRect(x: tapLocation.x - (width / 2),
                                       y: tapLocation.y - (height / 2),
                                       width: width, height: height)
        newObjectView.delegate = self
        return newObjectView
    }

    private func removeAllBoardObjectsFromView() {
        objectsToViews.values.forEach({ $0.removeFromSuperview() })
        objectsToViews = [:]
        viewsToObjects = [:]
    }

    private func insertSubview(for objectWrapper: BoardObjectWrapper) {
        let object = objectWrapper.object
        let newView = createBoardObjectView(with: object, at: object.position)

        // Check whether the newView was set
        guard let viewToInsert = newView else { return }
        boardView.addSubview(viewToInsert)
        viewToInsert.delegate = self
        viewToInsert.layer.transform = CATransform3DMakeRotation(object.rotation, 0, 0, 1)

        // Update dictionaries
        objectsToViews[objectWrapper] = viewToInsert
        viewsToObjects[viewToInsert] = objectWrapper
    }

    // MARK: Remove Notification
    deinit {
        notificationCenter.removeObserver(self, name: .objectAdded, object: nil)
        notificationCenter.removeObserver(self, name: .objectDeleted, object: nil)
        notificationCenter.removeObserver(self, name: .objectMoved, object: nil)
        notificationCenter.removeObserver(self, name: .objectResizeSuccess, object: nil)
        notificationCenter.removeObserver(self, name: .boardCleared, object: nil)
    }
}
