//
//  Block.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 16/2/23.
//

import Foundation

class Block: BoardObject {
    var position: CGPoint

    var rotation: Double

    var height: Double

    var width: Double

    static let defaultHeight: Double = 20.0
    static let defaultWidth: Double = 20.0

    init?(position: CGPoint,
          rotation: Double,
          height: Double,
          width: Double) {
        self.position = position
        self.rotation = rotation
        if height < 0 || width < 0 {
            return nil
        }
        self.height = height
        self.width = width
    }

    func isOverlapping(with otherObject: BoardObject) -> Bool {
        otherObject.isOverlapping(with: self)
    }

    func isOverlapping(with otherObject: Peg) -> Bool {
        DetectOverlap.detectOverlap(objectA: self, objectB: otherObject)
    }

    func isOverlapping(with otherObject: Block) -> Bool {
        // TODO: Change the implementation for this
        return false
    }

    func isEqual(to otherObject: BoardObject) -> Bool {
        guard let otherBlock = otherObject as? Block else {
            return false
        }

        return ObjectIdentifier(otherBlock) == ObjectIdentifier(self)
    }

    func isOutOfBounds(lowerX: Double, upperX: Double, lowerY: Double, upperY: Double) -> Bool {
        // TODO: Change implementation for this
        return false
    }

}
