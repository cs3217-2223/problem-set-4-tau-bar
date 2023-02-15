import UIKit
import CoreData

class LevelBuilderViewController: UIViewController {
    // MARK: View objects
    @IBOutlet var bluePegButton: SelectPegButton!
    @IBOutlet var orangePegButton: SelectPegButton!
    @IBOutlet var deletePegButton: SelectPegButton!
    @IBOutlet var levelNameTextField: UITextField!
    @IBOutlet var boardView: UIView!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var loadButton: UIButton!

    // MARK: Model objects
    var board: Board? {
        didSet {
            removeAllBoardObjectsFromView()
            loadObjectsFromModelOnBoard()
            setTextFieldText(to: board?.name ?? Board.DefaultBoardName)
        }
    }

    // MARK: Variables and properties
    var buttons: [SelectPegButton] = []
    var selectedButton: SelectPegButton? {
        didSet {
            let unselectedButtons = buttons.filter({ button in button != selectedButton })
            setButtonsTranslucent(unselectedButtons)
            guard let selectedButton = selectedButton else { return }
            setButtonOpaque(selectedButton)
        }
    }
    var currentSelectedColour: PegColor? {
        guard let selectedButton = selectedButton else { return nil }
        return buttonColors[selectedButton]
    }
    var objectsToViews: [BoardObjectWrapper: UIView] = [:]
    var viewsToObjects: [UIView: BoardObjectWrapper] = [:]
    let notificationCenter = NotificationCenter.default
    var buttonColors: [SelectPegButton: PegColor] = [:]

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //        DataManager.sharedInstance.createBoardData()

        // Set up peg buttons
        buttons = [bluePegButton, orangePegButton, deletePegButton]
        buttonColors[bluePegButton] = PegColor.blue
        buttonColors[orangePegButton] = PegColor.orange

        // Initialize empty board with current boardView size
        // if no board passed to controller
        if board == nil {
            board = createEmptyBoard()
        }

        // Register for notifications from model
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addObjectToBoardView), name: .objectAdded, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteObjectFromBoardView), name: .objectDeleted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moveObjectOnBoardView), name: .objectMoved, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearBoardView), name: .boardCleared, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notifyUserSaved), name: .dataSaved, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notifyUserSaveError), name: .dataSaveError,
                                               object: nil)

        // Select blue peg button by default when view is loaded
        selectButton(bluePegButton)
    }

    // MARK: Interaction handler functions
    /// Selects the peg button that was tapped.
    @IBAction func pegButtonTapped(_ sender: SelectPegButton) {
        selectButton(sender)
    }

    /// Runs when the board view is tapped.
    /// If an add peg button is selected, a peg is added.
    /// Otherwise, do nothing.
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: boardView)
        if let addedPegColour = currentSelectedColour {
            guard let newPeg = Peg(colour: addedPegColour, position: tapLocation) else {
                return
            }

            addObject(addedObjectWrapper: BoardObjectWrapper(object: newPeg))
        }
    }

    /// Resets the level to be empty when the reset button is tapped.
    @IBAction func resetButtonTapped(_ sender: Any) {
        board?.removeAllObjects()
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToGameView", sender: self)
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

    func addObject(addedObjectWrapper: BoardObjectWrapper) {
        board?.addObject(addedObjectWrapper: addedObjectWrapper)
    }

    func deleteObject(of deletedView: UIView) {
        guard let deletedObjectWrapper = viewsToObjects[deletedView] else {
            return
        }

        board?.removeObject(removedObjectWrapper: deletedObjectWrapper)
    }

    func moveObject(of sender: UIPanGestureRecognizer) {
        guard let movedView = sender.view,
              let movedObjectWrapper = viewsToObjects[movedView] else {
            return
        }

        let newLocation = sender.location(in: boardView)
        board?.moveObject(movedObjectWrapper: movedObjectWrapper, to: newLocation)
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
        Board(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    /// Sets a new text to the level name text field.
    private func setTextFieldText(to newName: String) {
        levelNameTextField.text = newName
    }

    /// Returns the text currently in the level name text field.
    private func getLevelName() -> String? {
        levelNameTextField.text
    }

    /// Set the button which was selected to be opaque.
    func selectButton(_ button: SelectPegButton) {
        selectedButton = button
    }

    /// Sets a peg button to be opaque.
    func setButtonOpaque(_ button: SelectPegButton) {
        button.alpha = SelectPegButton.SelectedAlphaValue
    }

    /// Set the buttons to lower opacity.
    func setButtonsTranslucent(_ unselectedButtons: [SelectPegButton]) {
        unselectedButtons.forEach({ button in
            button.alpha = SelectPegButton.UnselectedAlphaValue
        })
    }

    private func loadObjectsFromModelOnBoard() {
        board?.objects.forEach({
            insertSubview(for: $0)
        })
    }

    /// Creates a new `BoardPegView` using the data from the specified `Peg` and location.
    private func createBoardPegView(with addedPeg: Peg, at tapLocation: CGPoint) -> BoardPegView? {
        let pegSize = addedPeg.radius * 2
        guard let pegImageUrl = getImageUrl(from: addedPeg.colour) else { return nil }
        let newPegImageView = BoardPegView(image: UIImage(named: pegImageUrl), id: ObjectIdentifier(addedPeg))
        newPegImageView.frame = CGRect(x: tapLocation.x - addedPeg.radius,
                                       y: tapLocation.y - addedPeg.radius,
                                       width: pegSize, height: pegSize)
        newPegImageView.delegate = self
        return newPegImageView
    }

    func removeAllBoardObjectsFromView() {
        objectsToViews.values.forEach({ $0.removeFromSuperview() })
        objectsToViews = [:]
        viewsToObjects = [:]
    }

    // TODO: Cleanup this function
    func insertSubview(for objectWrapper: BoardObjectWrapper) {
        let object = objectWrapper.object

        if object is Peg {
            guard let peg = object as? Peg,
                  let newPegView = createBoardPegView(with: peg, at: peg.position) else {
                return
            }
            boardView.addSubview(newPegView)
            newPegView.delegate = self
            objectsToViews[objectWrapper] = newPegView
            viewsToObjects[newPegView] = objectWrapper
        }
    }

    func isDeletePegButton(selectedButton: SelectPegButton?) -> Bool {
        selectedButton == deletePegButton
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
        notificationCenter.removeObserver(self, name: .boardCleared, object: nil)
        notificationCenter.removeObserver(self, name: .dataSaved, object: nil)
        notificationCenter.removeObserver(self, name: .dataSaveError, object: nil)

    }
}
