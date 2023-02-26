//
//  MSKPhysicsWorldTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

final class MSKPhysicsWorldTests: XCTestCase {
    var physicsWorld: MSKPhysicsWorld?
    let defaultTestAccuracy: Double = 0.0000001
    let defaultTimeInterval: Double = 0.1
    var circlePhysicsBody = MSKCirclePhysicsBody(delegate: nil,
                                             positionLast: SIMD2<Double>(x: 0.0, y: 1.0),
                                             position: SIMD2<Double>(x: 1.0, y: 2.0),
                                             acceleration: SIMD2<Double>(x: 1.0, y: 1.0),
                                             affectedByGravity: true,
                                             isDynamic: true,
                                             categoryBitMask: 0xFFFFFFFF,
                                             mass: 1.0,
                                             radius: 5.0,
                                             angle: 0.5)

    override func setUp() {
        super.setUp()
        physicsWorld = MSKPhysicsWorld(bodies: [],
                                       gravity: SIMD2<Double>(0, 1.0),
                                       width: 500,
                                       height: 500,
                                       substeps: 2)
    }

    func testInit() {
        guard let physicsWorld = physicsWorld else {
            return XCTFail("physicsWorld is nil")
        }

        XCTAssertEqual(physicsWorld.gravity.x, 0)
        XCTAssertEqual(physicsWorld.gravity.y, 1)
        XCTAssertEqual(physicsWorld.width, 500)
        XCTAssertEqual(physicsWorld.height, 500)
    }

    func testAddBody_shouldAddBody() {
        XCTAssertEqual(physicsWorld?.bodiesCount, 0)

        physicsWorld?.addBody(circlePhysicsBody)

        XCTAssertEqual(physicsWorld?.bodiesCount, 1)
    }

    func testRemoveBody_bodyExists_shouldRemoveBody() {
        XCTAssertEqual(physicsWorld?.bodiesCount, 0)

        physicsWorld?.addBody(circlePhysicsBody)

        XCTAssertEqual(physicsWorld?.bodiesCount, 1)

        physicsWorld?.removeBody(circlePhysicsBody)

        XCTAssertEqual(physicsWorld?.bodiesCount, 0)
    }

    func testRemoveBody_bodyNotExists_shouldDoNothing() {
        XCTAssertEqual(physicsWorld?.bodiesCount, 0)

        physicsWorld?.removeBody(circlePhysicsBody)

        XCTAssertEqual(physicsWorld?.bodiesCount, 0)
    }

    func testSimulatePhysics_noCollisions_shouldUpdatePosition() {
        // Stationary object
        let originalPosition = circlePhysicsBody.position
        circlePhysicsBody.positionLast = originalPosition

        XCTAssertEqual(physicsWorld?.bodiesCount, 0)
        physicsWorld?.addBody(circlePhysicsBody)
        XCTAssertEqual(physicsWorld?.bodiesCount, 1)

        physicsWorld?.simulatePhysics(timeInterval: defaultTimeInterval)

        // Gravity applied should cause y position to update
        XCTAssertTrue(circlePhysicsBody.position.y > originalPosition.y)
    }

    func testSimulatePhysics_collision_shouldUpdatePosition() {
        // Stationary objects
        let originalPosition = circlePhysicsBody.position
        circlePhysicsBody.positionLast = originalPosition

        // Overlapping circlePhysicsBody on x-axis --> Collision should occur
        let otherBody = MSKCirclePhysicsBody(circleOfRadius: 1.0,
                                         center: SIMD2<Double>(x: 0.9, y: 2.0),
                                         isDynamic: true, rotation: 0)

        physicsWorld?.addBody(circlePhysicsBody)
        physicsWorld?.addBody(otherBody)
        physicsWorld?.simulatePhysics(timeInterval: defaultTimeInterval)

        // Gravity applied should cause y position to update
        XCTAssertTrue(circlePhysicsBody.position.y > originalPosition.y)
        XCTAssertTrue(otherBody.position.y > 2.0)

        // Collision between otherBody and circlePhysicsBody should result in otherBody
        // going to left and circlePhysicsBody going to right.
        XCTAssertTrue(circlePhysicsBody.position.x > originalPosition.x)
        XCTAssertTrue(otherBody.position.x < 1.0)
    }

    func testAddTopBorder_shouldEnforceBoundary() {
        XCTAssertEqual(physicsWorld?.bodiesCount, 0)

        let outOfBoundsBody = MSKCirclePhysicsBody(circleOfRadius: 20,
                                                   center: SIMD2<Double>(x: 50, y: 19),
                                                   isDynamic: true, rotation: 0)
        physicsWorld?.addTopBorder(xPos: 50, yPos: 0, width: 1_000)
        physicsWorld?.addBody(outOfBoundsBody)
        physicsWorld?.simulatePhysics(timeInterval: defaultTimeInterval)
        XCTAssertTrue(outOfBoundsBody.position.y >= 20)
    }

    func testAddLeftBorder_shouldEnforceBoundary() {
        XCTAssertEqual(physicsWorld?.bodiesCount, 0)

        let outOfBoundsBody = MSKCirclePhysicsBody(circleOfRadius: 20,
                                                   center: SIMD2<Double>(x: 19, y: 50),
                                                   isDynamic: true, rotation: 0)
        physicsWorld?.addLeftBorder(xPos: 0, yPos: 50, height: 1_000)
        physicsWorld?.addBody(outOfBoundsBody)
        physicsWorld?.simulatePhysics(timeInterval: defaultTimeInterval)
        XCTAssertTrue(outOfBoundsBody.position.x >= 20)
    }

    func testAddRightBorder_shouldEnforceBoundary() {
        XCTAssertEqual(physicsWorld?.bodiesCount, 0)

        let outOfBoundsBody = MSKCirclePhysicsBody(circleOfRadius: 20,
                                                   center: SIMD2<Double>(x: 481, y: 50),
                                                   isDynamic: true, rotation: 0)
        physicsWorld?.addRightBorder(xPos: 500, yPos: 50, height: 1_000)
        physicsWorld?.addBody(outOfBoundsBody)
        physicsWorld?.simulatePhysics(timeInterval: defaultTimeInterval)
        XCTAssertTrue(outOfBoundsBody.position.x <= 480)
    }
}
