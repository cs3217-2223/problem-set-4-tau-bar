//
//  CGPoint+StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation
import CoreData
import CoreGraphics

extension CGPoint: StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject {
        let pointData = CGPointData(context: context)
        pointData.x = x
        pointData.y = y
        return pointData as NSManagedObject
    }
}
