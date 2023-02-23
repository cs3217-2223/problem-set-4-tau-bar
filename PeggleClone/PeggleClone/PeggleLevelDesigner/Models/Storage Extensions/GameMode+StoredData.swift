//
//  GameMode+StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation
import CoreData

extension GameMode: StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject {
        let gameModeData = GameModeData(context: context)
        gameModeData.mode = self.rawValue
        return gameModeData as NSManagedObject
    }
}
