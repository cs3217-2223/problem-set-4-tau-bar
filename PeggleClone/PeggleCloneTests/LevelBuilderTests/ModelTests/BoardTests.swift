//
//  BoardTests.swift
//  PeggleLevelDesignerTests
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//

import XCTest

final class BoardTests: XCTestCase {
    let defaultBoardWidth: Double = 500
    let defaultBoardHeight: Double = 700
    let screenCentreX: Double = 250
    let screenCentreY: Double = 350

    func testConstructBoard_shouldReturnNonNil() {
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)

        XCTAssertNotNil(board, "Board should not be nil.")
    }

    func testAddPeg_shouldInsertPeg() {
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let addedPeg = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }

        expectation(forNotification: .pegAdded, object: addedPeg)
        board.addPeg(addedPeg)
        waitForExpectations(timeout: 4)
        XCTAssertEqual(board.pegs.count, 1, "Pegs count should be 1 after adding peg.")
    }

    func testAddPeg_pegAlreadyExists_shouldNotAddNewPeg() {
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let addedPeg = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(addedPeg)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        board.addPeg(addedPeg)

        XCTAssertEqual(board.pegs.count, 1, "Board should still have 1 peg.")
    }

    func testAddPeg_pegOverlapping_shouldNotAddNewPeg() {
        let overlappedPegPosition = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let overlappedPeg = Peg(colour: PegColour.orange, position: overlappedPegPosition, radius: 1.0) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(overlappedPeg)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        let addedPegPosition = Position(xPos: screenCentreX + 1.0, yPos: screenCentreY + 1.0)
        guard let addedPeg = Peg(colour: PegColour.orange, position: addedPegPosition, radius: 1.0) else {
            return XCTFail("Created peg should not be nil.")
        }

        board.addPeg(addedPeg)

        XCTAssertEqual(board.pegs.count, 1, "Board should still have 1 peg.")
    }

    func testAddPeg_pegOutOfBounds_shouldNotAddNewPeg() {
        let outOfBoundsPosition = Position(xPos: defaultBoardWidth, yPos: defaultBoardHeight)
        guard let outOfBoundsPeg = Peg(colour: PegColour.orange, position: outOfBoundsPosition, radius: 1.0) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)

        board.addPeg(outOfBoundsPeg)

        XCTAssertEqual(board.pegs.count, 0, "Board should have 0 pegs.")
    }

    func testRemovePeg_shouldRemovePeg() {
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let removedPeg = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(removedPeg)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        expectation(forNotification: .pegDeleted, object: removedPeg)
        board.removePeg(removedPeg)
        waitForExpectations(timeout: 4)

        XCTAssertEqual(board.pegs.count, 0, "Board should have 0 pegs.")
    }

    func testRemovePeg_pegNotInBoard_shouldDoNothing() {
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let pegInBoard = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(pegInBoard)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        guard let pegNotInBoard = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }

        board.removePeg(pegNotInBoard)

        XCTAssertEqual(board.pegs.count, 1, "Board should still have 1 peg.")
    }

    func testMovePeg_pegInBoard_withinBounds_noOverlap_shouldMovePeg() {
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let movedPeg = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }

        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(movedPeg)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        let newPosition = Position(xPos: screenCentreX + 2.0, yPos: screenCentreY + 2.0)
        expectation(forNotification: .pegMoved, object: movedPeg)
        board.movePeg(movedPeg, toPosition: newPosition)
        waitForExpectations(timeout: 4)

        XCTAssertEqual(movedPeg.getPosition(), newPosition, "Peg position should have changed.")
    }

    func testMovePeg_pegNotInBoard_shouldDoNothing() {
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let pegInBoard = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }

        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(pegInBoard)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")
        guard let pegNotInBoard = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }

        let newPosition = Position(xPos: screenCentreX + 1.0, yPos: screenCentreY + 1.0)
        board.movePeg(pegNotInBoard, toPosition: newPosition)

        XCTAssertEqual(board.pegs.count, 1, "Board should still have 1 peg.")
        XCTAssertEqual(pegInBoard.getPosition(), position, "Peg should not have changed.")
    }

    func testMovePeg_pegOverlapping_shouldNotMovePeg() {
        let overlappedPegPosition = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let overlappedPeg = Peg(colour: PegColour.orange, position: overlappedPegPosition, radius: 1.0)
        else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(overlappedPeg)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        let movedPegInitialPosition = Position(xPos: screenCentreX + 10.0, yPos: screenCentreY + 10.0)
        guard let movedPeg = Peg(colour: PegColour.orange, position: movedPegInitialPosition, radius: 1.0)
        else {
            return XCTFail("Created peg should not be nil.")
        }
        board.addPeg(movedPeg)
        XCTAssertEqual(board.pegs.count, 2, "Board should have 2 pegs.")

        let overlappingPosition = Position(xPos: overlappedPegPosition.xPos, yPos: overlappedPegPosition.yPos)
        let originalPosition = movedPeg.getPosition()
        board.movePeg(movedPeg, toPosition: overlappingPosition)

        XCTAssertEqual(movedPeg.getPosition(), originalPosition, "Peg should not have moved.")

    }

    func testMovePeg_pegOutOfBounds_shouldNotMovePeg() {
        let initialPosition = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let outOfBoundsPeg = Peg(colour: PegColour.orange, position: initialPosition, radius: 1.0) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)

        let outOfBoundsPosition = Position(xPos: defaultBoardWidth, yPos: defaultBoardHeight)
        let originalPosition = outOfBoundsPeg.getPosition()

        board.movePeg(outOfBoundsPeg, toPosition: outOfBoundsPosition)

        XCTAssertEqual(outOfBoundsPeg.getPosition(), originalPosition,
                       "Peg should not be moved to an out of bounds position.")
    }

    func testFindPegById_ifPegExists_returnsPeg() {
        let position = Position(xPos: screenCentreX, yPos: screenCentreY)
        guard let pegInBoard = Peg(colour: PegColour.orange, position: position) else {
            return XCTFail("Created peg should not be nil.")
        }

        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(pegInBoard)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 1 peg.")

        let pegId = ObjectIdentifier(pegInBoard)
        let foundPeg = board.findPegById(pegId)

        XCTAssertEqual(foundPeg, pegInBoard, "Peg with wrong id returned.")
    }

    func removeAllPegs_shouldRemoveAllPegs() {
        let position1 = Position(xPos: screenCentreX, yPos: screenCentreY)
        let position2 = Position(xPos: screenCentreX + 5, yPos: screenCentreY + 5)
        guard let peg1 = Peg(colour: PegColour.orange, position: position1) else {
            return XCTFail("Created peg should not be nil.")
        }
        guard let peg2 = Peg(colour: PegColour.blue, position: position2) else {
            return XCTFail("Created peg should not be nil.")
        }
        let board = Board(width: defaultBoardWidth, height: defaultBoardHeight)
        board.addPeg(peg1)
        board.addPeg(peg2)
        XCTAssertEqual(board.pegs.count, 1, "Board should have 2 pegs.")

        expectation(forNotification: .boardCleared, object: nil)
        board.removeAllPegs()
        waitForExpectations(timeout: 4)
        XCTAssertEqual(board.pegs.count, 0, "Board should have 0 pegs.")
    }

}
