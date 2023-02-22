//
//  FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

/**
 `FetchedData` allows structs which conform to it to be initialized from Core Data types.
 */
import CoreData

protocol FetchedData {
    associatedtype PeggleCloneData: NSManagedObject

    init(data: PeggleCloneData) throws
}
