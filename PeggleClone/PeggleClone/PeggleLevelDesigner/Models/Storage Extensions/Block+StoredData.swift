//
//  Block+StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation
import CoreData

extension Block: StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject {
        let blockData = BlockData(context: context)
        blockData.positionData = position.toCoreDataObject(context: context) as? CGPointData
        blockData.width = width
        blockData.height = height
        blockData.rotation = rotation
        return blockData as NSManagedObject
    }
}
