//
//  BoardsTransformer.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 26/1/23.
//

import Foundation

@objc(BoardsTransformer)
final class BoardsTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: BoardsTransformer.self))

    override class var allowedTopLevelClasses: [AnyClass] {
        super.allowedTopLevelClasses + [Board.self]
    }

    class func register() {
        let transformer = BoardsTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}