//
//  DataManager.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 24/1/23.
//

import CoreData
import UIKit

enum DataCodingKeys: String, CodingKey {
    case boards
}

open class DataManager: NSObject {

    public static let sharedInstance = DataManager()

    static let BoardDataEntityName = "BoardData"

    override private init() {}

    private lazy var boardDataEntity: NSEntityDescription = {
        let managedContext = getContext()
        return NSEntityDescription.entity(forEntityName: DataManager.BoardDataEntityName, in: managedContext!)!
    }()

    /// Saves a new board to Core Data.
    /// If a board with the same name already exists, overwrite the old board with the new board.
    func saveBoard(_ board: Board, onComplete completionHandler: () -> Void) {
        guard let data = retrieveData() else { return }

        var boards: [Board] = []
        if let pastBoards = data.value(forKey: DataCodingKeys.boards.rawValue) as? [Board] {
            boards += pastBoards.filter({ pastBoard in pastBoard.name != board.name })
        }
        boards.append(board)
        saveBoards(boards)
    }

    /// Deletes all saved boards from Core Data.
    func deleteAllBoards() {
        saveBoards([])
    }

    /// Saves the specified collection of boards into Core Data.
    func saveBoards(_ updatedBoards: [Board]) {
        guard let managedContext = getContext() else { return }
        guard let data = retrieveData() else { return }

        data.setValue(updatedBoards, forKey: DataCodingKeys.boards.rawValue)

        do {
            print("Saving board...")
            try managedContext.save()
            sendNotification(of: .dataSaved)
        } catch let error as NSError {
            print("Failed to save board data! \(error): \(error.userInfo)")
            sendNotification(of: .dataSaveError)
        }
    }

    /// Retrieves the current `NSManagedObjectContext` from the `persistentContainer` in `AppDelegate`.
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }

    /// Retrieves the latest `BoardData` from Core Data.
    func retrieveData() -> BoardData? {
        guard let managedContext = getContext() else { return nil }
        let fetchRequest = BoardData.fetchRequest()
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                return result[0]
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Retrieving data failed. \(error): \(error.userInfo)")
            return nil
        }
    }

    /// Sends a notification to all observers of the Board class instance with a specified
    /// notification type and peg.
    private func sendNotification(of type: NSNotification.Name) {
        NotificationCenter.default.post(name: type, object: nil)
    }
}

extension DataManager {
    /// Creates new board data with fresh starting data.
    func createBoardData() {
        guard let managedContext = getContext() else { return }
        _ = NSManagedObject(entity: boardDataEntity, insertInto: managedContext)

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to create board data! \(error): \(error.userInfo)")
        }
    }
}
