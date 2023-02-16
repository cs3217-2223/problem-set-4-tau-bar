//
//  PegTests.swift
//  PeggleLevelDesignerTests
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//

import XCTest

final class PegTests: XCTestCase {
    var peg: Peg?

    override func setUp() {
        super.setUp()
        peg = Peg(colour: .orange, position: .zero, radius: 1.5)
    }

    override func tearDown() {
        peg = nil
    }

    func testInit() {
        XCTAssertNotNil(peg, "Peg should not be nil.")
    }

    func testConstructPeg_validRadius_shouldReturnNonNil() {
        XCTAssertNotNil(peg, "Peg should not be nil.")
        XCTAssertEqual(peg?.colour, .orange)
        XCTAssertEqual(peg?.position, .zero)
        XCTAssertEqual(peg?.radius, 1.5)
    }

    func testConstructPeg_invalidRadius_shouldReturnNil() {
        let pegRadiusZero = Peg(colour: .orange, position: .zero, radius: 0.0)
        let pegRadiusNegative = Peg(colour: .orange, position: .zero, radius: -1.5)

        XCTAssertNil(pegRadiusZero, "Peg with radius zero should not be created.")
        XCTAssertNil(pegRadiusNegative, "Peg with negative radius should not be created.")
    }

    func testMovePeg_toNewPosition_shouldChangePosition() {
        let peg = Peg(colour: .orange, position: .zero, radius: 1.5)
        let newPosition = CGPoint(x: 1.0, y: 1.0)

        peg?.move(to: newPosition)

        XCTAssertEqual(peg?.position, newPosition, "Peg should have new position.")
    }
}
