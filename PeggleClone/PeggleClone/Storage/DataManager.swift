//
//  DataManager.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation
import CoreData

class DataManager {

    let context: NSManagedObjectContext
    let coreDataManager: CoreDataManager

    init() {
        let manager = CoreDataManager()
        self.coreDataManager = manager
        self.context = manager.context
    }

    func hasBoard(with boardName: String) throws -> Bool {
        do {
            let boardData = try findBoards(with: boardName)
            if boardData.count > 0 {
                return true
            } else if boardData.count == 0 {
                return false
            }
        } catch {
            print("Could not read Core Data.")
        }
        return false
    }

    func fetchBoardData(boardName: String) throws -> BoardData {
        let boardData = try findBoards(with: boardName)

        guard boardData.count > 0 else {
            throw StorageError.boardDoesNotExist
        }

        guard boardData.count == 1 else {
            throw StorageError.duplicateBoardName
        }
        return boardData[0]
    }

    func save(board: Board, overwrite: Bool = false) throws {
        guard let boardData = try? findBoards(with: board.name) else { return }
        if !boardData.isEmpty && !overwrite {
            throw StorageError.duplicateBoardName
        } else if overwrite {
            // Overwrite board(s) with same name by deleting
            for datum in boardData {
                context.delete(datum)
            }
        }

        // Then saving the new board with the board name
        _ = board.toCoreDataObject(context: context)
        try context.save()
    }

    func fetchAllBoardData() throws -> [BoardData] {
        let request = BoardData.fetchRequest()
        return try context.fetch(request)
    }

    func delete(board: Board) throws {
        guard let boardData = try? findBoards(with: board.name) else { return }
        for datum in boardData {
            context.delete(datum)
        }
    }

    func deleteAllBoards() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BoardData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }

    private func findBoards(with name: String) throws -> [BoardData] {
        let fetchRequest = createBoardDataFetchRequest(with: "name == '\(name)'")
        return try context.fetch(fetchRequest)
    }

    private func createBoardDataFetchRequest(with condition: String) -> NSFetchRequest<BoardData> {
        let request = BoardData.fetchRequest() as NSFetchRequest<BoardData>
        let predicate = NSPredicate(format: condition)
        request.predicate = predicate
        return request
    }

    private func sendNotification(of type: NSNotification.Name) {
        NotificationCenter.default.post(name: type, object: nil)
    }
}
