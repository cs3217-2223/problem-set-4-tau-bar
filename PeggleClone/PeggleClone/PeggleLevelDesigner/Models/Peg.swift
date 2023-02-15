//
//  Peg.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//
/**
 `Peg` represents a peg in the level designer board.
 
 The representation invariants:
 - Radius is greater than 0
 */
import Foundation

enum PegKeys: String, CodingKey {
    case colour, radius, position
}

class Peg: BoardObject {
    var position: CGPoint

    var rotation: Double

    var height: Double {
        radius * 2
    }

    var width: Double {
        radius * 2
    }

    let colour: PegColor

    let radius: Double

    static let defaultPegRadius = 20.0
    static let defaultPegRotation = 0.0
    static var supportsSecureCoding = true

    // MARK: Initializers
    init?(colour: PegColor, position: CGPoint, rotation: Double = defaultPegRotation, radius: Double = defaultPegRadius) {
        self.colour = colour
        self.position = position
        self.rotation = rotation
        if radius <= 0 {
            return nil
        }
        self.radius = radius
    }

    convenience init?(colour: PegColor, position: CGPoint) {
        self.init(colour: colour, position: position, radius: Self.defaultPegRadius)
    }

    /// Moves the peg to `newPosition`.
    func move(to newPosition: CGPoint) {
        position = newPosition
    }

    /// Checks whether the peg object is overlapping with another `BoardObject`.
    func isOverlapping(with otherObject: BoardObject) -> Bool {
        otherObject.isOverlapping(with: self)
    }

    /// Checks whether the peg object is overlapping with another `Peg`.
    func isOverlapping(with otherObject: Peg) -> Bool {
        let distanceBetween = calculateEuclideanDistance(positionA: position, positionB: otherObject.position)
        return distanceBetween < (otherObject.radius + radius)
    }

    func isEqual(to otherObject: BoardObject) -> Bool {
        guard let otherPeg = otherObject as? Peg else {
            return false
        }

        return ObjectIdentifier(otherPeg) == ObjectIdentifier(self)
    }

    func isOutOfBounds(lowerX: Double, upperX: Double, lowerY: Double, upperY: Double) -> Bool {
        position.x + radius > upperX ||
        position.x - radius < lowerX ||
        position.y - radius < lowerY ||
        position.y + radius > upperY
    }
}
