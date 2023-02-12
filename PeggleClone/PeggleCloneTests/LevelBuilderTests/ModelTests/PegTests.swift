//
//  PegTests.swift
//  PeggleLevelDesignerTests
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//

import XCTest

final class PegTests: XCTestCase {

    func testConstructPeg_validRadius_shouldReturnNonNil() {
        let pegPosition = Position(xPos: 0.0, yPos: 0.0)
        let peg = Peg(colour: PegColour.orange, position: pegPosition, radius: 1.5)

        XCTAssertNotNil(peg, "Peg should not be nil.")
        XCTAssertEqual(peg?.colour, PegColour.orange)
        XCTAssertEqual(peg?.getPosition(), pegPosition)
        XCTAssertEqual(peg?.radius, 1.5)
    }

    func testConstructPeg_invalidRadius_shouldReturnNil() {
        let pegRadiusZero = Peg(colour: PegColour.orange, position: Position(xPos: 0.0, yPos: 0.0), radius: 0.0)
        let pegRadiusNegative = Peg(colour: PegColour.orange, position: Position(xPos: 0.0, yPos: 0.0), radius: -1.5)

        XCTAssertNil(pegRadiusZero, "Peg with radius zero should not be created.")
        XCTAssertNil(pegRadiusNegative, "Peg with negative radius should not be created.")
    }

    func testMovePeg_toNewPosition_shouldChangePosition() {
        let peg = Peg(colour: PegColour.orange, position: Position(xPos: 0.0, yPos: 0.0), radius: 1.5)
        let newPosition = Position(xPos: 1.0, yPos: 2.0)

        peg?.movePeg(toPosition: newPosition)

        XCTAssertEqual(peg?.getPosition(), newPosition, "Peg should have new position.")
    }
}
