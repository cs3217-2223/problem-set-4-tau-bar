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

    let asset: String

    static let defaultHeight: Double = 40.0
    static let defaultWidth: Double = 40.0
    static let defaultBlockRotation = 0.0

    init?(position: CGPoint,
          rotation: Double = defaultBlockRotation,
          height: Double = defaultHeight,
          width: Double = defaultWidth) {
        self.position = position
        self.rotation = rotation
        if height < 0 || width < 0 {
            return nil
        }
        self.height = height
        self.width = width
        self.asset = "black"
    }

    func isOverlapping(with otherObject: BoardObject) -> Bool {
        otherObject.isOverlapping(with: self)
    }

    func isOverlapping(with otherObject: Peg) -> Bool {
        DetectOverlap.detectOverlap(objectA: self, objectB: otherObject)
    }

    func isOverlapping(with otherObject: Block) -> Bool {
        if DetectOverlap.detectOverlap(objectA: self, objectB: otherObject) {
            return true
        }
        return false
    }

    func isEqual(to otherObject: BoardObject) -> Bool {
        guard let otherBlock = otherObject as? Block else {
            return false
        }

        return ObjectIdentifier(otherBlock) == ObjectIdentifier(self)
    }

    func isOutOfBounds(lowerX: Double, upperX: Double, lowerY: Double, upperY: Double) -> Bool {
        let blockLowerX = position.x - width / 2
        let blockUpperX = position.x + width / 2
        let blockLowerY = position.y - height / 2
        let blockUpperY = position.y + height / 2

        return blockLowerX < lowerX || blockUpperX > upperX || blockLowerY < lowerY || blockUpperY > upperY
    }

    func setSize(to newSize: Double) {
        height = newSize
        width = newSize
    }
}
