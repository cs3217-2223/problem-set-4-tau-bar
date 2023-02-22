//
//  BuilderViewController.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//

import UIKit

class LevelSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var deleteAllLevelsButton: UIButton!
    @IBOutlet var tableView: UITableView!

    var boards: [Board] = []
    var delegate: LevelSelectViewControllerDelegate?
    var dataManager: DataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerTableViewCells()

        reloadTableView()
    }

    /// Loads an empty board in the delegate's view when user taps on 'New Level' button.
    @IBAction func newLevelButtonTapped(_ sender: Any) {
        self.delegate?.loadEmptyBoard()
        dismissLevelSelect()
    }

    /// Deletes all saved boards when user taps on the 'Delete All Levels' button.
    @IBAction func deleteAllLevelsButtonTapped(_ sender: Any) {
        do {
            try dataManager?.deleteAllBoards()
            reloadTableView()
        } catch {
            print(error)
        }
    }

    /// Returns the number of rows that the table should load.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        boards.count
    }

    /// Returns the cell view to be displayed in the table view at a specified row.
    internal func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell") as? LevelTableViewCell {
            cell.label?.text = boards[indexPath.row].name
            return cell
        }

        return UITableViewCell()
    }

    /// Loads selected board to the LevelBuilderViewController (delegate) when a row is tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBoard = boards[indexPath.row]
        self.delegate?.loadBoard(selectedBoard)
        dismissLevelSelect()
    }

    /// Specifies the height of the table cell view.
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            100
    }

    /// Deletes a saved board when user swipes left on a cell.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            do {
                boards.remove(at: indexPath.row)
                try dataManager?.delete(board: boards[indexPath.row])
                try loadBoardDatas()
            } catch {
                print(error)
                print("Unable to fetch board data from Core Data.")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }

    /// Retrieves latest board data from the Data Manager to populate the table.
    func reloadTableView() {
        do {
            try loadBoardDatas()
            tableView.reloadData()
        } catch {
            print(error)
        }
    }

    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "LevelTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "LevelTableViewCell")
    }

    private func dismissLevelSelect() {
        self.dismiss(animated: true)
    }
    
    private func loadBoardDatas() throws {
        let boardDatas = try dataManager?.fetchAllLevelData()
        boards = []
        boardDatas?.forEach({
            do {
                try boards.append(Board.createBoard(with: $0))
            } catch {
                print("Board data was invalid, skipping.")
            }
        })
    }
}
