//
//  Peg+StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation
import CoreData

extension Peg: StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject {
        let pegData = PegData(context: context)
        pegData.positionData = position.toCoreDataObject(context: context) as? CGPointData
        pegData.radius = radius
        pegData.rotation = rotation
        pegData.colorData = color.toCoreDataObject(context: context) as? PegColorData
        return pegData as NSManagedObject
    }
}
