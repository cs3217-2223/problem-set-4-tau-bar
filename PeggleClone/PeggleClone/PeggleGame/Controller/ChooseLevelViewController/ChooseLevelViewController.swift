//
//  ChooseLevelViewController.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 14/2/23.
//

import UIKit

class ChooseLevelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var backButton: UIButton!
    var boards: [Board] = []
    private var dataManager = DataManager()
    @IBOutlet var tableView: UITableView!
    private var selectedBoard: Board?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerTableViewCells()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        reloadTableView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        selectedBoard = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLevelToGame" {
            guard let gameVc = segue.destination as? GameViewController else { return }
            gameVc.board = selectedBoard
        }
    }

    @IBAction func unwindFromGameViewControllerToChooseLevel(_ segue: UIStoryboardSegue) {}

    /// Returns the number of rows that the table should load.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        boards.count
    }

    /// Returns the cell view to be displayed in the table view at a specified row.
    internal func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseLevelViewCell") as? ChooseLevelViewCell {
            let currentBoard = boards[indexPath.row]
            cell.ballCount.text = String(currentBoard.balls)
            cell.gameModeLabel.text = currentBoard.gameMode.rawValue

            var blue = 0, orange = 0, purple = 0, green = 0, red = 0, block = 0
            for objectWrapper in currentBoard.objects {
                let obj = objectWrapper.object
                if let peg = obj as? Peg {
                    switch peg.color {
                    case .blue:
                        blue += 1
                        continue
                    case .orange:
                        orange += 1
                        continue
                    case .purple:
                        purple += 1
                        continue
                    case .green:
                        green += 1
                        continue
                    case .red:
                        red += 1
                        continue
                    }
                } else if obj is Block {
                    block += 1
                }
            }

            cell.blueCount.text = String(blue)
            cell.blockCount.text = String(block)
            cell.greenCount.text = String(green)
            cell.orangeCount.text = String(orange)
            cell.redCount.text = String(red)
            cell.purpleCount.text = String(purple)
            cell.nameLabel.text = currentBoard.name
            return cell
        }

        return UITableViewCell()
    }

    /// Play board when row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBoard = boards[indexPath.row]
        performSegue(withIdentifier: "chooseLevelToGame", sender: nil)
    }

    /// Specifies the height of the table cell view.
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            200
    }

    /// Deletes a saved board when user swipes left on a cell.
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            do {
                try dataManager.delete(board: boards[indexPath.row])
                boards.remove(at: indexPath.row)
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
        let textFieldCell = UINib(nibName: "ChooseLevelViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "ChooseLevelViewCell")
    }

    private func loadBoardDatas() throws {
        let boardDatas = try dataManager.fetchAllBoardData()
        boards = []
        boardDatas.forEach({
            do {
                try boards.append(Board.createBoard(with: $0))
            } catch {
                print("Board data was invalid, skipping.")
            }
        })
    }
}
