//
//  Board.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//
/**
 `Board` represents the board in the level designer. `Peg` objects are placed on the board.
 
 The model invariants:
 - The board cannot have more than one peg with the same position.
 - Pegs should not overlap on the board.
 - Pegs should not partially/fully go out of the board (should stay within the game area)
 */
import Foundation

enum BoardKeys: String, CodingKey {
    case pegs, height, width, name
}

public class Board: NSObject, BoardProtocol, NSSecureCoding {
    // MARK: Variables and Properties
    var pegs: Set<Peg>
    let height: Double
    let width: Double
    var name: String = DefaultBoardName

    static let DefaultBoardName = ""
    public static var supportsSecureCoding: Bool = true

    // MARK: Initializers
    init(width: Double, height: Double) {
        self.pegs = Set()
        self.width = width
        self.height = height
    }

    init(pegs: Set<Peg>, width: Double, height: Double, name: String) {
        self.pegs = pegs
        self.width = width
        self.height = height
        self.name = name
    }

    /// Required initializer for conforming with NSSecureCoding protocol to support persistence of board data.
    required convenience public init?(coder: NSCoder) {
        guard let pegs = coder.decodeObject(of: [NSSet.self, Peg.self], forKey: BoardKeys.pegs.rawValue) as? Set<Peg>,
              let name = coder.decodeObject(of: NSString.self, forKey: BoardKeys.name.rawValue) as? String
        else {
            return nil
        }
        let height = coder.decodeDouble(forKey: BoardKeys.height.rawValue)
        let width = coder.decodeDouble(forKey: BoardKeys.width.rawValue)

        self.init(pegs: pegs, width: width, height: height, name: name)
    }

    // MARK: BoardProtocol methods

    /// Adds a new peg onto the board.
    ///
    /// If the added peg already exists in the board, the peg is not added.
    /// If the added peg overlaps another existing peg
    /// on the board or is out of the board's bounds, the peg is not added.
    ///
    /// If the peg is added, a notification is sent to the observers of the
    /// instance of the Board class.
    func addPeg(_ addedPeg: Peg) {
        if pegs.contains(addedPeg) {
            return
        }

        if findOverlappingPegs(with: addedPeg)
            || isPegOutOfBounds(addedPeg) {
            return
        }

        pegs.insert(addedPeg)

        sendNotification(of: .pegAdded, with: addedPeg)
    }

    /// Removes a specified peg from the board.
    ///
    /// If the board does not contain the specified peg, do nothing.
    ///
    /// If the peg is removed, a notification is sent to observers of the
    /// instance of the Board class.
    func removePeg(_ removedPeg: Peg) {
        if !pegs.contains(removedPeg) {
            return
        }

        pegs.remove(removedPeg)

        sendNotification(of: .pegDeleted, with: removedPeg)
    }

    /// Removes all pegs from the board.
    ///
    /// Notification is sent to observers of the instance of Board class.
    func removeAllPegs() {
        pegs = Set()

        sendNotification(of: .boardCleared, with: nil)
    }

    /// Moves a specified peg to the new specified position on the board.
    ///
    /// If moving the peg will cause overlap with another peg or
    /// out of board's bounds, the peg is not moved.
    ///
    /// If the peg is moved, a notification sent to observers of instance of
    /// Board class.
    func movePeg(_ movedPeg: Peg, toPosition newPosition: Position) {
        if !pegs.contains(movedPeg) {
            return
        }

        let oldPosition = movedPeg.getPosition()

        movedPeg.movePeg(toPosition: newPosition)

        if findOverlappingPegs(with: movedPeg)
            || isPegOutOfBounds(movedPeg) {
            movedPeg.movePeg(toPosition: oldPosition)
            return
        }

        sendNotification(of: .pegMoved, with: movedPeg)
    }

    /// Finds a peg object on the board by its Object Identifier.
    func findPegById(_ id: ObjectIdentifier) -> Peg? {
        pegs.first(where: { peg in
            ObjectIdentifier(peg) == id
        })
    }

    /// Sends a notification to all observers of the Board class instance with a specified
    /// notification type and peg.
    private func sendNotification(of type: NSNotification.Name, with object: Peg?) {
        NotificationCenter.default.post(name: type, object: object)
    }

    /// Checks whether there are any pegs which will overlap the newly added peg.
    ///
    /// If there is an overlap with another peg, return true. Else, return false.
    private func findOverlappingPegs(with pegToCheck: Peg) -> Bool {
        return pegs.contains(where: { peg in
            if peg === pegToCheck {
                return false
            }

            let distance = calculateEuclidianDistance(firstPeg: peg, secondPeg: pegToCheck)
            return distance < (pegToCheck.radius + peg.radius)
        })
    }

    /// Checks whether the newly added peg is out of the board's bounds.
    ///
    /// If the peg is out of bounds, return true. Else, return false.
    private func isPegOutOfBounds(_ pegToCheck: Peg) -> Bool {
        let position = pegToCheck.getPosition()
        let pegRadius = pegToCheck.radius
        if position.xPos + pegRadius > width
            || position.xPos - pegRadius < 0
            || position.yPos + pegRadius > height
            || position.yPos - pegRadius < 0 {
            return true
        }
        return false
    }

    /// Calculates the 2D Euclidian distance between two pegs.
    private func calculateEuclidianDistance(firstPeg: Peg, secondPeg: Peg) -> Double {
        let firstPegPosition = firstPeg.getPosition()
        let secondPegPosition = secondPeg.getPosition()
        let distance = sqrt(pow(firstPegPosition.xPos - secondPegPosition.xPos, 2)
             + pow(firstPegPosition.yPos - secondPegPosition.yPos, 2))
        return distance
    }

    /// Encodes the board instance to support persistence of board data.
    public func encode(with coder: NSCoder) {
        coder.encode(pegs, forKey: BoardKeys.pegs.rawValue)
        coder.encode(width, forKey: BoardKeys.width.rawValue)
        coder.encode(height, forKey: BoardKeys.height.rawValue)
        coder.encode(name, forKey: BoardKeys.name.rawValue)
    }
}
