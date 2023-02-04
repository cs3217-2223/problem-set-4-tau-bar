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

class Peg: NSObject, NSSecureCoding {

    // MARK: Variables and Properties
    let colour: PegColour
    private var position: Position
    let radius: Double

    static let DefaultPegRadius = 20.0
    static var supportsSecureCoding: Bool = true

    // MARK: Initializers
    init?(colour: PegColour, position: Position, radius: Double) {
        self.colour = colour
        self.position = position
        if radius <= 0 {
            return nil
        }
        self.radius = radius
        super.init()
        assert(checkRepresentation())
    }

    required convenience init?(coder: NSCoder) {
        guard let pegColourString = coder.decodeObject(of: NSString.self, forKey: PegKeys.colour.rawValue) as? String,
              let position = coder.decodeObject(of: Position.self, forKey: PegKeys.position.rawValue),
              let colour = PegColour(rawValue: pegColourString)
        else {
            return nil
        }
        let radius = coder.decodeDouble(forKey: PegKeys.radius.rawValue)

        self.init(colour: colour, position: position, radius: radius)
    }

    convenience init?(colour: PegColour, position: Position) {
        self.init(colour: colour, position: position, radius: Self.DefaultPegRadius)
        assert(checkRepresentation())
    }

    // MARK: Class methods
    func movePeg(toPosition: Position) {
        position = toPosition
        assert(checkRepresentation())
    }

    func getPosition() -> Position {
        position
    }

    /// Checks the representation invariants.
    private func checkRepresentation() -> Bool {
        return radius > 0
    }

    /// Encodes the peg instance to support persistence of peg data.
    func encode(with coder: NSCoder) {
        coder.encode(colour.rawValue, forKey: PegKeys.colour.rawValue)
        coder.encode(radius, forKey: PegKeys.radius.rawValue)
        coder.encode(position, forKey: PegKeys.position.rawValue)
    }
}
