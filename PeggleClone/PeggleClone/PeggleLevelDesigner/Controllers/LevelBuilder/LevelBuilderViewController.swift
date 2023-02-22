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

    // Delegate references
    weak var actionsDelegate: LevelBuilderActionsDelegate?
    var selectedObject: BoardObjectWrapper?
    
    // Model objects
    var board: Board? {
        didSet {
            removeAllBoardObjectsFromView()
            loadObjectsFromModelOnBoard()
            setTextFieldText(to: board?.name ?? Board.DefaultBoardName)
        }
    }

    // Helper variables & properties
    var objectsToViews: [BoardObjectWrapper: BoardObjectView] = [:]
    var viewsToObjects: [BoardObjectView: BoardObjectWrapper] = [:]
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        //        DataManager.sharedInstance.createBoardData()
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
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUserSaved),
                                               name: .dataSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUserSaveError),
                                               name: .dataSaveError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resizeObjectOnBoardView),
                                               name: .objectResizeSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedObjectOnBoardView),
                                               name: .objectRotateSuccess, object: nil)
    }

    // MARK: Interaction handler functions
    /// Runs when the board view is tapped.
    /// If an add peg button is selected, a peg is added.
    /// Otherwise, do nothing.
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
        //        DataManager.sharedInstance.saveBoard(board, onComplete: alertUserLevelSaved)
    }

    @IBAction func unwindFromGameViewController(_ segue: UIStoryboardSegue) {}

    /// Opens the view showing the saved levels when the load button is tapped.
    @IBAction func loadButtonTapped(_ sender: Any) {
        guard let levelSelectVC = self
            .storyboard?.instantiateViewController(identifier: "LevelSelectViewController")
                as? LevelSelectViewController else { return }
        levelSelectVC.delegate = self
        self.present(levelSelectVC, animated: true)
    }

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

    func resizeObject(_ object: BoardObjectWrapper, to newSize: Double) {
        board?.resizeObject(object, to: newSize)
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
        resizedView?.frame = frame
        resizedView?.center.x = resizedObjectWrapper.object.position.x
        resizedView?.center.y = resizedObjectWrapper.object.position.y
    }

    @objc func rotatedObjectOnBoardView(_ notification: Notification) {
        guard let rotatedObjectWrapper = notification.object as? BoardObjectWrapper else { return }

        guard let rotatedView = objectsToViews[rotatedObjectWrapper] else { return }
        rotatedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        rotatedView.contentMode = .scaleToFill
        rotatedView.layer.transform = CATransform3DMakeRotation(rotatedObjectWrapper.object.rotation, 0, 0, 1)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameView" {
            guard let gameVc = segue.destination as? GameViewController else { return }
            gameVc.board = board
        }
    }

    // MARK: Helper functions
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

    func removeAllBoardObjectsFromView() {
        objectsToViews.values.forEach({ $0.removeFromSuperview() })
        objectsToViews = [:]
        viewsToObjects = [:]
    }

    func insertSubview(for objectWrapper: BoardObjectWrapper) {
        let object = objectWrapper.object
        let newView = createBoardObjectView(with: object, at: object.position)

        // Check whether the newView was set
        guard let viewToInsert = newView else { return }
        boardView.addSubview(viewToInsert)
        viewToInsert.delegate = self

        // Update dictionaries
        objectsToViews[objectWrapper] = viewToInsert
        viewsToObjects[viewToInsert] = objectWrapper
    }

    /// Presents an alert to user that no level name was entered.
    private func alertUserNoName() {
        let alert = UIAlertController(title: "No name", message: "Please enter level name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in NSLog("The alertUserNoName alert occured.") }))
        self.present(alert, animated: true, completion: nil)
    }

    /// Presents an alert to inform user that level has saved.
    private func alertUserLevelSaved() {
        let alert = UIAlertController(title: "Level saved", message: "Your level is saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in NSLog("The alertUserLevelSaved alert occured.") }))
        self.present(alert, animated: true, completion: nil)
    }

    private func alertUserSaveError() {
        let alert = UIAlertController(title: "Error while saving",
                                      message: "There was an error saving your level.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in NSLog("The alertUserSaveError alert occured.") }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: Remove Notification
    deinit {
        notificationCenter.removeObserver(self, name: .objectAdded, object: nil)
        notificationCenter.removeObserver(self, name: .objectDeleted, object: nil)
        notificationCenter.removeObserver(self, name: .objectMoved, object: nil)
        notificationCenter.removeObserver(self, name: .objectResizeSuccess, object: nil)
        notificationCenter.removeObserver(self, name: .objectRotateSuccess, object: nil)
        notificationCenter.removeObserver(self, name: .boardCleared, object: nil)
        notificationCenter.removeObserver(self, name: .dataSaved, object: nil)
        notificationCenter.removeObserver(self, name: .dataSaveError, object: nil)
    }
}
