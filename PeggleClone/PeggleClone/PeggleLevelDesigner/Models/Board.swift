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

public class Board {
    /// The set of board objects on the board.
    var objects: Set<BoardObjectWrapper>
    /// The height of the board.
    let height: Double
    /// The width of the board.
    let width: Double
    /// The name of the board.
    var name: String = defaultBoardName
    /// Number of balls which are available to shoot on the board.
    var balls: Int = defaultBalls
    /// The board's game mode.
    var gameMode: GameMode = .classic

    /// The default board name.
    static let defaultBoardName = ""

    /// The default number of balls
    static let defaultBalls = 1

    // MARK: Initializers
    /**
     Initializes a board instance with the specified `width` and `height` values.
     
     - Parameters:
        - width: The width of the board.
        - height: The height of the board.
     */
    init(width: Double, height: Double) {
        self.objects = []
        self.width = width
        self.height = height
    }

    /**
     Initializes a board instance with the specified `objects`, `width`, `height`, and `name` values.
     
     - Parameters:
        - objects: The set of board objects to be on the board.
        - width: The width of the board.
        - height: The height of the board.
        - name: The name of the board.
        - balls: The number of balls for the board.
        - gameMode: The game mode of the board.
     */
    init(objects: Set<BoardObjectWrapper>,
         width: Double,
         height: Double,
         name: String,
         balls: Int = defaultBalls,
         gameMode: GameMode = .classic) {
        self.objects = objects
        self.width = width
        self.height = height
        self.name = name
        self.balls = balls
        self.gameMode = gameMode
    }

    /**
     Adds a `BoardObjectWrapper` to the board if it does not overlap with any other objects on the board
     and is within the board's bounds. If the object already exists, do nothing.
     
     - Parameters:
        - addedObjectWrapper: The `BoardObjectWrapper` to be added.
     */
    func addObject(_ addedObjectWrapper: BoardObjectWrapper) {
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

    /**
     Removes a `BoardObjectWrapper` from the board. If the object doesn't exist, do nothing.
     
     - Parameters:
        - removedObjectWrapper: The `BoardObjectWrapper` to be removed.
     */
    func removeObject(_ removedObjectWrapper: BoardObjectWrapper) {
        if !objects.contains(removedObjectWrapper) {
            return
        }

        objects.remove(removedObjectWrapper)
        sendNotification(of: .objectDeleted, with: removedObjectWrapper)
    }

    /**
     Moves a `BoardObjectWrapper` to a new position if the new position does not overlap
     with any other objects on the board and is within the board's bounds.
     
     - Parameters:
        - movedObjectWrapper: The `BoardObjectWrapper` to be moved.
        - newPosition: The new position to move the object to.
     */
    func moveObject(_ movedObjectWrapper: BoardObjectWrapper, to newPosition: CGPoint) {
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

        sendNotification(of: .objectMoved, with: movedObjectWrapper)
    }

    func resizeObject(_ resizedObjectWrapper: BoardObjectWrapper, to newSize: Double) {
        let resizedObject = resizedObjectWrapper.object
        let oldWidth = resizedObject.width
        resizedObject.setSize(to: newSize)

        if hasOverlappingObjects(with: resizedObjectWrapper) ||
            isOutOfBounds(resizedObjectWrapper) {
            resizedObject.setSize(to: oldWidth)
            sendNotification(of: .objectResizeFail, with: resizedObjectWrapper)
            return
        }

        sendNotification(of: .objectResizeSuccess, with: resizedObjectWrapper)
    }

    func rotateObject(_ rotatedObjectWrapper: BoardObjectWrapper, to rotation: Double) -> Bool {
        let rotatedObject = rotatedObjectWrapper.object
        let oldRotation = rotatedObject.rotation
        rotatedObject.rotation = rotation

        if hasOverlappingObjects(with: rotatedObjectWrapper) ||
            isOutOfBounds(rotatedObjectWrapper) {
            rotatedObject.rotation = oldRotation
            return false
        }
        
        return true
    }

    /// Checks whether the specified object is overlapping with any other objects on the board.
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

    /// Checks whther the object is out of bounds of the board.
    func isOutOfBounds(_ checkedObjectWrapper: BoardObjectWrapper) -> Bool {
        checkedObjectWrapper.object.isOutOfBounds(lowerX: 0,
                                                  upperX: width,
                                                  lowerY: 0,
                                                  upperY: height)
    }

    func removeAllObjects() {
        objects = Set()
        sendNotification(of: .boardCleared, with: nil)
    }

    private func sendNotification(of type: NSNotification.Name, with object: BoardObjectWrapper?) {
        NotificationCenter.default.post(name: type, object: object)
    }
}
