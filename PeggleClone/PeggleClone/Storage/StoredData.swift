//
//  StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

/**
 To store objects in Core Data, they need to conform to `StoredData`.
 
 For example, a `Peg` object can be stored as a `PegData` object.
 */

import CoreData

protocol StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject
}
