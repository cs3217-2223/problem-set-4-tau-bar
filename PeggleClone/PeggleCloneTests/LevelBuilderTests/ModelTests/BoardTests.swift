//
//  BoardTests.swift
//  ObjectgleLevelDesignerTests
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//

import XCTest

final class BoardTests: XCTestCase {
    let defaultBoardWidth: Double = 500
    let defaultBoardHeight: Double = 700
    let screenCenterX: Double = 250
    let screenCenterY: Double = 350
    var pegWrapper: BoardObjectWrapper?
    var board: Board?

    override func setUp() {
        super.setUp()
        board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        guard let peg = Peg(colour: .orange, position: CGPoint(x: 250, y: 350)) else {
            return
        }
        pegWrapper = BoardObjectWrapper(object: peg)
    }

    override func tearDown() {
        board?.removeAllObjects()
        board = nil
    }

    func testInit() {
        XCTAssertNotNil(board, "Board should not be nil.")
    }

    func testAddObject_shouldInsertObject() {
        expectation(forNotification: .objectAdded, object: pegWrapper)
        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)
        waitForExpectations(timeout: 4)
        XCTAssertEqual(board?.objects.count, 1, "Objects count should be 1 after adding object.")
    }

    func testAddObject_pegAlreadyExists_shouldNotAddNewObject() {
        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        board?.addObject(pegWrapper)

        XCTAssertEqual(board?.objects.count, 1, "Board should still have 1 object.")
    }

    func testAddObject_pegOverlapping_shouldNotAddNewObject() {
        let overlappedObjectPosition = CGPoint(x: screenCenterX, y: screenCenterY)
        guard let overlappedObject = Peg(colour: .orange, position: overlappedObjectPosition, radius: 1.0) else {
            return XCTFail("Created object should not be nil.")
        }

        board?.addObject(BoardObjectWrapper(object: overlappedObject))
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)

        XCTAssertEqual(board?.objects.count, 1, "Board should still have 1 object.")
    }

    func testAddObject_pegOutOfBounds_shouldNotAddNewObject() {
        let outOfBoundsPosition = CGPoint(x: defaultBoardWidth, y: defaultBoardHeight)
        guard let outOfBoundsObject = Peg(colour: PegColor.orange, position: outOfBoundsPosition, radius: 1.0) else {
            return XCTFail("Created object should not be nil.")
        }

        board?.addObject(BoardObjectWrapper(object: outOfBoundsObject))

        XCTAssertEqual(board?.objects.count, 0, "Board should have 0 pegs.")
    }

    func testRemoveObject_shouldRemoveObject() {
        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        expectation(forNotification: .objectDeleted, object: pegWrapper)
        board?.removeObject(pegWrapper)
        waitForExpectations(timeout: 4)

        XCTAssertEqual(board?.objects.count, 0, "Board should have 0 pegs.")
    }

    func testRemoveObject_pegNotInBoard_shouldDoNothing() {
        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        guard let pegNotInBoard = Peg(colour: PegColor.orange, position: CGPoint(x: screenCenterX, y: screenCenterY)) else {
            return XCTFail("Created object should not be nil.")
        }

        board?.removeObject(BoardObjectWrapper(object: pegNotInBoard))

        XCTAssertEqual(board?.objects.count, 1, "Board should still have 1 object.")
    }

    func testMoveObject_pegInBoard_withinBounds_noOverlap_shouldMoveObject() {
        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        let newPosition = CGPoint(x: screenCenterX + 2.0, y: screenCenterY + 2.0)
        expectation(forNotification: .objectMoved, object: pegWrapper)
        board?.moveObject(pegWrapper, to: newPosition)
        waitForExpectations(timeout: 4)

        XCTAssertEqual(pegWrapper.object.position, newPosition, "Peg position should have changed.")
    }

    func testMoveObject_pegNotInBoard_shouldDoNothing() {
        guard let pegWrapper = pegWrapper else { return }
        board?.addObject(pegWrapper)
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        let position = CGPoint(x: screenCenterX, y: screenCenterY)
        guard let pegNotInBoard = Peg(colour: PegColor.orange, position: position) else {
            return XCTFail("Created object should not be nil.")
        }

        let newPosition = CGPoint(x: screenCenterX + 1.0, y: screenCenterY + 1.0)
        board?.moveObject(BoardObjectWrapper(object: pegNotInBoard), to: newPosition)

        XCTAssertEqual(board?.objects.count, 1, "Board should still have 1 object.")
        XCTAssertEqual(pegWrapper.object.position, position, "Peg should not have changed.")
    }

    func testMoveObject_pegOverlapping_shouldNotMoveObject() {
        let overlappedObjectPosition = CGPoint(x: screenCenterX, y: screenCenterY)
        guard let overlappedObject = Peg(colour: PegColor.orange, position: overlappedObjectPosition, radius: 1.0)
        else {
            return XCTFail("Created object should not be nil.")
        }

        board?.addObject(BoardObjectWrapper(object: overlappedObject))
        XCTAssertEqual(board?.objects.count, 1, "Board should have 1 object.")

        let movedObjectInitialPosition = CGPoint(x: screenCenterX + 10.0, y: screenCenterY + 10.0)
        guard let movedObject = Peg(colour: PegColor.orange, position: movedObjectInitialPosition, radius: 1.0)
        else {
            return XCTFail("Created object should not be nil.")
        }

        let movedObjectWrapper = BoardObjectWrapper(object: movedObject)
        board?.addObject(movedObjectWrapper)
        XCTAssertEqual(board?.objects.count, 2, "Board should have 2 pegs.")

        let overlappingPosition = CGPoint(x: overlappedObjectPosition.x, y: overlappedObjectPosition.y)
        let originalPosition = movedObject.position
        board?.moveObject(movedObjectWrapper, to: overlappingPosition)

        XCTAssertEqual(movedObjectWrapper.object.position, originalPosition, "Peg should not have moved.")

    }

    func testMoveObject_pegOutOfBounds_shouldNotMoveObject() {
        let outOfBoundsPosition = CGPoint(x: defaultBoardWidth, y: defaultBoardHeight)
        let originalPosition = pegWrapper?.object.position

        guard let pegWrapper = pegWrapper else { return }
        board?.moveObject(pegWrapper, to: outOfBoundsPosition)

        XCTAssertEqual(pegWrapper.object.position, originalPosition,
                       "Peg should not be moved to an out of bounds position.")
    }

    func removeAllObjects_shouldRemoveAllObjects() {
        let position1 = CGPoint(x: screenCenterX, y: screenCenterY)
        let position2 = CGPoint(x: screenCenterX + 5, y: screenCenterY + 5)
        guard let peg1 = Peg(colour: PegColor.orange, position: position1) else {
            return XCTFail("Created object should not be nil.")
        }
        guard let peg2 = Peg(colour: PegColor.blue, position: position2) else {
            return XCTFail("Created object should not be nil.")
        }
        board?.addObject(BoardObjectWrapper(object: peg1))
        board?.addObject(BoardObjectWrapper(object: peg2))
        XCTAssertEqual(board?.objects.count, 2, "Board should have 2 pegs.")

        expectation(forNotification: .boardCleared, object: nil)
        board?.removeAllObjects()
        waitForExpectations(timeout: 4)
        XCTAssertEqual(board?.objects.count, 0, "Board should have 0 pegs.")
    }

}
