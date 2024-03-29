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

enum PegColor: String {
    case blue, orange, purple, red, green
}

class Peg: BoardObject {
    static let pegAssets = [PegColor.blue: "peg-blue",
                            PegColor.orange: "peg-orange",
                            PegColor.red: "peg-red",
                            PegColor.purple: "peg-purple",
                            PegColor.green: "peg-green"]

    var position: CGPoint

    var rotation: Double

    var height: Double {
        radius * 2
    }

    var width: Double {
        radius * 2
    }

    let color: PegColor

    var radius: Double

    let asset: String

    static let defaultPegRadius = 20.0
    static let defaultPegRotation = 0.0
    static var supportsSecureCoding = true

    // MARK: Initializers
    required init(color: PegColor,
                  position: CGPoint,
                  rotation: Double = defaultPegRotation,
                  radius: Double = defaultPegRadius,
                  asset: String) {

        self.asset = asset
        self.radius = radius
        self.color = color
        self.position = position
        self.rotation = rotation
    }

    init?(colour: PegColor,
          position: CGPoint,
          rotation: Double = defaultPegRotation,
          radius: Double = defaultPegRadius) {
        if radius <= 0 {
            return nil
        }

        guard let asset = Peg.pegAssets[colour] else { return nil }

        self.asset = asset
        self.radius = radius
        self.color = colour
        self.position = position
        self.rotation = rotation
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
        DetectOverlap.detectOverlap(objectA: otherObject, objectB: self)
    }

    func isOverlapping(with otherObject: Block) -> Bool {
        DetectOverlap.detectOverlap(objectA: otherObject, objectB: self)
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

    func setSize(to newSize: Double) {
        radius = newSize / 2
    }
}
