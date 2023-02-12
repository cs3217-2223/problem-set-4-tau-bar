import UIKit
import CoreData

class LevelBuilderViewController: UIViewController,
                                    BoardPegViewDelegate,
                                  LevelSelectViewControllerDelegate {

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
            removeAllBoardPegsFromBoardView()
            loadPegsFromModelOnBoard()
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
    var currentSelectedColour: PegColour? {
        guard let selectedButton = selectedButton else { return nil }
        return buttonColours[selectedButton]
    }
    var pegToViewDict: [Peg: BoardPegView] = [:]
    let notificationCenter = NotificationCenter.default
    var buttonColours: [SelectPegButton: PegColour] = [:]

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.sharedInstance.createBoardData()

        // Set up peg buttons
        buttons = [bluePegButton, orangePegButton, deletePegButton]
        buttonColours[bluePegButton] = PegColour.blue
        buttonColours[orangePegButton] = PegColour.orange

        // Initialize empty board with current boardView size
        // if no board passed to controller
        if board == nil {
            board = createEmptyBoard()
        }

        // Register for notifications from model
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addPegToBoardView), name: .pegAdded, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deletePegFromBoardView), name: .pegDeleted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(movePegOnBoardView), name: .pegMoved, object: nil)
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
            addPeg(at: tapLocation, with: addedPegColour)
        }
    }

    /// Resets the level to be empty when the reset button is tapped.
    @IBAction func resetButtonTapped(_ sender: Any) {
        resetBoard()
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToGameView", sender: self)
    }

    @IBAction func unwindFromGameViewController(_ segue: UIStoryboardSegue) {
    }

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
        DataManager.sharedInstance.saveBoard(board, onComplete: alertUserLevelSaved)
    }

    // MARK: Delegate functions for `BoardPegView`
    /// Deletes a board peg that was long pressed from the level.
    /// Delegate function for long press on `BoardPegView`.
    func userDidLongPress(boardPegView: BoardPegView) {
        deletePeg(of: boardPegView)
    }

    /// Deletes a board peg from the level if the user taps on it and if the delete peg button is selected.
    /// Otherwise, do nothing.
    /// Delegate function for tap on `BoardPegView`.
    func userDidTap(boardPegView: BoardPegView) {
        if isDeletePegButton(selectedButton: selectedButton) {
            deletePeg(of: boardPegView)
        }
    }

    /// Moves a peg on the board that was panned to the new location on the level if valid.
    /// Otherwise, do nothing.
    /// Delegate function for pan on `BoardPegView`.
    func userDidPan(sender: UIPanGestureRecognizer) {
        movePeg(of: sender)
    }

    // MARK: Notification Functions
    /// Adds a peg to the board view when receive .pegAdded notification from board model.
    @objc func addPegToBoardView(_ notification: Notification) {
        guard let newPeg = notification.object as? Peg else {
            return
        }

        insertPegSubview(with: newPeg)
    }

    /// Deletes a peg from the board view when receive .pegDeleted notification from board model.
    @objc func deletePegFromBoardView(_ notification: Notification) {
        guard let deletedPeg = notification.object as? Peg else {
            return
        }

        let deletedBoardPegView = pegToViewDict[deletedPeg]

        deletedBoardPegView?.removeFromSuperview()
        pegToViewDict.removeValue(forKey: deletedPeg)
    }

    /// Moves a peg on the board view when receive .pegMoved notification from board model.
    @objc func movePegOnBoardView(_ notification: Notification) {
        guard let movedPeg = notification.object as? Peg else { return }

        let movedPegView = pegToViewDict[movedPeg]

        movedPegView?.center.x = movedPeg.getPosition().xPos
        movedPegView?.center.y = movedPeg.getPosition().yPos
    }

    /// Clears board view when receive .boardCleared notification from board model.
    @objc func clearBoardView(_ notification: Notification) {
        removeAllBoardPegsFromBoardView()
    }

    @objc func notifyUserSaved() {
        alertUserLevelSaved()
    }

    @objc func notifyUserSaveError() {
        alertUserSaveError()
    }

    // MARK: LevelSelectViewController delegate functions
    /// Loads a board from delegatee  as the board for the level builder.
    func loadBoard(_ loadedBoard: Board) {
        board = loadedBoard
    }

    func loadEmptyBoard() {
        board = createEmptyBoard()
    }

    // MARK: Model functions
    /// Add a new peg to the board model.
    func addPeg(at tapLocation: CGPoint, with colour: PegColour) {
        guard let addedPeg = Peg(colour: colour,
                                 position: Position(xPos: tapLocation.x, yPos: tapLocation.y))
        else {
            return
        }

        board?.addPeg(addedPeg)
    }

    /// Delete a peg from the board model.
    func deletePeg(of deletedPegView: BoardPegView) {
        guard let deletedId = deletedPegView.id,
              let deletedPeg = board?.findPegById(deletedId)
        else {
            return
        }

        board?.removePeg(deletedPeg)
    }

    /// Move a peg on the board model.
    func movePeg(of sender: UIPanGestureRecognizer) {
        guard let movedBoardPegView = sender.view as? BoardPegView,
              let movedId = movedBoardPegView.id,
              let movedPeg = board?.findPegById(movedId)
        else {
            return
        }

        let newLocation = sender.location(in: boardView)
        board?.movePeg(movedPeg, toPosition: convertCgPointToPosition(newLocation))
    }

    /// Resets the board model.
    func resetBoard() {
        board?.removeAllPegs()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameView" {
            guard let gameVc = segue.destination as? GameViewController else { return }
            gameVc.board = board
        }
    }

    // MARK: Helper functions
    private func createEmptyBoard() -> Board {
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

    /// Loads the pegs from the board model onto the level builder board view.
    private func loadPegsFromModelOnBoard() {
        board?.pegs.forEach({ peg in
            insertPegSubview(with: peg)
        })
    }

    /// Inserts the specified peg as a subview of the controller's board view.
    private func insertPegSubview(with newPeg: Peg) {
        let newLocation = convertPositionToCgPoint(newPeg.getPosition())
        guard let newPegImageView = createBoardPegView(with: newPeg, at: newLocation) else { return }

        newPegImageView.delegate = self

        boardView.addSubview(newPegImageView)
        pegToViewDict[newPeg] = newPegImageView
    }

    /// Creates a new `BoardPegView` using the data from the specified `Peg` and location.
    private func createBoardPegView(with addedPeg: Peg, at tapLocation: CGPoint) -> BoardPegView? {
        let pegSize = getPegDiameter(addedPeg)
        guard let pegImageUrl = getImageUrl(from: addedPeg.colour) else { return nil }
        let newPegImageView = BoardPegView(image: UIImage(named: pegImageUrl), id: ObjectIdentifier(addedPeg))
        newPegImageView.frame = CGRect(x: tapLocation.x - addedPeg.radius,
                                       y: tapLocation.y - addedPeg.radius,
                                       width: pegSize, height: pegSize)
        newPegImageView.delegate = self
        return newPegImageView
    }

    /// Removes all the board pegs from the board view.
    func removeAllBoardPegsFromBoardView() {
        pegToViewDict.values.forEach({ boardPegView in boardPegView.removeFromSuperview() })

        pegToViewDict = [:]
    }

    private func getPegDiameter(_ peg: Peg) -> Double {
        peg.radius * 2
    }

    private func isDeletePegButton(selectedButton: SelectPegButton?) -> Bool {
        selectedButton == deletePegButton
    }

    private func convertCgPointToPosition(_ location: CGPoint) -> Position {
        Position(xPos: location.x, yPos: location.y)
    }

    private func convertPositionToCgPoint(_ position: Position) -> CGPoint {
        CGPoint(x: position.xPos, y: position.yPos)
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
        notificationCenter.removeObserver(self, name: .pegAdded, object: nil)
        notificationCenter.removeObserver(self, name: .pegDeleted, object: nil)
        notificationCenter.removeObserver(self, name: .pegMoved, object: nil)
        notificationCenter.removeObserver(self, name: .boardCleared, object: nil)
        notificationCenter.removeObserver(self, name: .dataSaved, object: nil)
        notificationCenter.removeObserver(self, name: .dataSaveError, object: nil)

    }
}
