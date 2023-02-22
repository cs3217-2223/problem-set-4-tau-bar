//
//  PegColor+StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation
import CoreData

extension PegColor: StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject {
        let pegColorData = PegColorData(context: context)
        pegColorData.color = self.rawValue
        return pegColorData as NSManagedObject
    }
}
