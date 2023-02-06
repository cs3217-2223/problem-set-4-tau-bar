//
//  BoardData+CoreDataProperties.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 24/1/23.
//
//

import Foundation
import CoreData

extension BoardData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BoardData> {
        NSFetchRequest<BoardData>(entityName: "BoardData")
    }

    @NSManaged public var boards: [Board]?

}

extension BoardData: Identifiable {

}
