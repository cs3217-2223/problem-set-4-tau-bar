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

public class Board {
    // MARK: Variables and Properties
    var objects: Set<BoardObjectWrapper>
    let height: Double
    let width: Double
    var name: String = DefaultBoardName

    static let DefaultBoardName = ""
    public static var supportsSecureCoding = true

    // MARK: Initializers
    init(width: Double, height: Double) {
        self.objects = []
        self.width = width
        self.height = height
    }

    init(objects: Set<BoardObjectWrapper>, width: Double, height: Double, name: String) {
        self.objects = objects
        self.width = width
        self.height = height
        self.name = name
    }

    private func sendNotification(of type: NSNotification.Name, with object: Peg?) {
        NotificationCenter.default.post(name: type, object: object)
    }

    func addObject(addedObjectWrapper: BoardObjectWrapper) {
        if objects.contains(addedObjectWrapper) {
            return
        }

        if hasOverlappingObjects(with: addedObjectWrapper) ||
            isOutOfBounds(addedObjectWrapper) {
            return
        }

        objects.insert(addedObjectWrapper)
        sendNotification(of: .objectAdded, with: addedObjectWrapper)
    }

    func removeObject(removedObjectWrapper: BoardObjectWrapper) {
        if !objects.contains(removedObjectWrapper) {
            print("doesn't contain")
            return
        }

        objects.remove(removedObjectWrapper)
        sendNotification(of: .objectDeleted, with: removedObjectWrapper)
    }

    func moveObject(movedObjectWrapper: BoardObjectWrapper, to newPosition: CGPoint) {
        if !objects.contains(movedObjectWrapper) {
            return
        }

        let movedObject = movedObjectWrapper.object
        let oldPosition = movedObject.position
        movedObject.position = newPosition

        if hasOverlappingObjects(with: movedObjectWrapper) ||
            isOutOfBounds(movedObjectWrapper) {
            movedObject.position = oldPosition
            return
        }

        print(movedObjectWrapper.object)
        sendNotification(of: .objectMoved, with: movedObjectWrapper)
    }

    func hasOverlappingObjects(with checkedObjectWrapper: BoardObjectWrapper) -> Bool {
        objects.contains(where: { objectWrapper in
            let checkedObject = checkedObjectWrapper.object
            let boardObject = objectWrapper.object

            // Doesn't overlap with itself
            if checkedObject.isEqual(to: boardObject) {
                return false
            }

            return boardObject.isOverlapping(with: checkedObject)
        })
    }

    func isOutOfBounds(_ checkedObjectWrapper: BoardObjectWrapper) -> Bool {
        checkedObjectWrapper.object.isOutOfBounds(lowerX: 0,
                                                  upperX: width,
                                                  lowerY: 0,
                                                  upperY: height)
    }

    func removeAllObjects() {
        objects = Set()
    }

    private func sendNotification(of type: NSNotification.Name, with object: BoardObjectWrapper?) {
        NotificationCenter.default.post(name: type, object: object)
    }

//    /// Encodes the board instance to support persistence of board data.
//    public func encode(with coder: NSCoder) {
//        coder.encode(objects, forKey: BoardKeys.pegs.rawValue)
//        coder.encode(width, forKey: BoardKeys.width.rawValue)
//        coder.encode(height, forKey: BoardKeys.height.rawValue)
//        coder.encode(name, forKey: BoardKeys.name.rawValue)
//    }
}
