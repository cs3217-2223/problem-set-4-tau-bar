//
//  MSKPhysicsBodyTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

final class MSKPhysicsBodyTests: XCTestCase {
    var circlePhysicsBody: MSKCirclePhysicsBody?
    let position = SIMD2<Double>(x: 1.0, y: 2.0)
    let oldPosition = SIMD2<Double>(x: 0.0, y: 1.0)
    let acceleration = SIMD2<Double>(x: 1.0, y: 1.0)
    let defaultTestAccuracy: Double = 0.0000001
    let defaultTimeInterval: Double = 0.1

    override func setUp() {
        super.setUp()
        circlePhysicsBody = MSKCirclePhysicsBody(delegate: nil,
                                                 positionLast: oldPosition,
                                                 position: position,
                                                 acceleration: acceleration,
                                                 affectedByGravity: true,
                                                 isDynamic: true,
                                                 categoryBitMask: 0xFFFFFFFF,
                                                 mass: 1.0,
                                                 radius: 5.0,
                                                 angle: 0.5)
    }

    func testInit() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("circlePhysicsBody is nil.")
        }

        XCTAssertEqual(circlePhysicsBody.positionLast, oldPosition)
        XCTAssertEqual(circlePhysicsBody.position, position)
        XCTAssertEqual(circlePhysicsBody.acceleration, acceleration)
        XCTAssertEqual(circlePhysicsBody.affectedByGravity, true)
        XCTAssertEqual(circlePhysicsBody.isDynamic, true)
        XCTAssertEqual(circlePhysicsBody.categoryBitMask, 0xFFFFFFFF)
        XCTAssertEqual(circlePhysicsBody.mass, 1.0)
        XCTAssertEqual(circlePhysicsBody.radius, 5.0)
        XCTAssertEqual(circlePhysicsBody.angle, 0.5)
    }

    func testUpdatePosition_dynamic_afterTimeInterval_updatesPositionCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("Body is nil")
        }
        XCTAssertEqual(circlePhysicsBody.positionLast, oldPosition)
        XCTAssertEqual(circlePhysicsBody.position, position)

        circlePhysicsBody.updatePosition(timeInterval: defaultTimeInterval)

        XCTAssertEqual(circlePhysicsBody.positionLast, position)
        XCTAssertEqual(circlePhysicsBody.position, SIMD2<Double>(2.01, 3.01))

    }

    func testUpdatePosition_nonDynamic_afterTimeInterval_updatesPositionCorrectly() {
        let nonDynamicBody = MSKCirclePhysicsBody(delegate: nil,
                                                 positionLast: oldPosition,
                                                 position: position,
                                                 acceleration: acceleration,
                                                 affectedByGravity: false,
                                                 isDynamic: false,
                                                 categoryBitMask: 0xFFFFFFFF,
                                                 mass: 1.0,
                                                 radius: 5.0,
                                                 angle: 0.5)

        XCTAssertEqual(nonDynamicBody.positionLast, oldPosition)
        XCTAssertEqual(nonDynamicBody.position, position)

        nonDynamicBody.updatePosition(timeInterval: defaultTimeInterval)

        XCTAssertEqual(nonDynamicBody.positionLast, oldPosition)
        XCTAssertEqual(nonDynamicBody.position, position)

    }

    func testUpdatePosition_dynamic_byVector_updatesPositionCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("Body is nil")
        }
        XCTAssertEqual(circlePhysicsBody.positionLast, oldPosition)
        XCTAssertEqual(circlePhysicsBody.position, position)

        let displacement = SIMD2<Double>(1.5, 1.5)
        circlePhysicsBody.updatePosition(by: displacement)

        XCTAssertEqual(circlePhysicsBody.positionLast, oldPosition)
        XCTAssertEqual(circlePhysicsBody.position, position + displacement)
    }

    func testUpdatePosition_nonDynamic_byVector_updatesPositionCorrectly() {
        let nonDynamicBody = MSKCirclePhysicsBody(delegate: nil,
                                                 positionLast: oldPosition,
                                                 position: position,
                                                 acceleration: acceleration,
                                                 affectedByGravity: false,
                                                 isDynamic: false,
                                                 categoryBitMask: 0xFFFFFFFF,
                                                 mass: 1.0,
                                                 radius: 5.0,
                                                 angle: 0.5)

        XCTAssertEqual(nonDynamicBody.positionLast, oldPosition)
        XCTAssertEqual(nonDynamicBody.position, position)

        let displacement = SIMD2<Double>(1.5, 1.5)
        nonDynamicBody.updatePosition(by: displacement)

        XCTAssertEqual(nonDynamicBody.positionLast, oldPosition)
        XCTAssertEqual(nonDynamicBody.position, position)
    }

    func testAccelerate_shouldUpdateAccelerationCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("Body is nil")
        }
        XCTAssertEqual(circlePhysicsBody.acceleration, acceleration)

        circlePhysicsBody.accelerate(acc: SIMD2<Double>(1.0, 5.0))

        XCTAssertEqual(circlePhysicsBody.acceleration, SIMD2<Double>(2.0, 6.0))
    }

    func testApplyGravity_bodyAffectedByGravity_shouldUpdateAcceleration() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("Body is nil")
        }
        XCTAssertEqual(circlePhysicsBody.acceleration, acceleration)

        circlePhysicsBody.applyGravity(SIMD2<Double>(0, -10.0))

        XCTAssertEqual(circlePhysicsBody.acceleration, SIMD2<Double>(1.0, -9.0))
    }

    func testApplyGravity_bodyNotAffectedByGravity_shouldNotUpdateAcceleration() {
        let nonGravityBody = MSKCirclePhysicsBody(delegate: nil,
                                                 positionLast: oldPosition,
                                                 position: position,
                                                 acceleration: acceleration,
                                                 affectedByGravity: false,
                                                 isDynamic: true,
                                                 categoryBitMask: 0xFFFFFFFF,
                                                 mass: 1.0,
                                                 radius: 5.0,
                                                 angle: 0.5)

        XCTAssertEqual(nonGravityBody.acceleration, acceleration)

        nonGravityBody.applyGravity(SIMD2<Double>(0, -10.0))

        XCTAssertEqual(nonGravityBody.acceleration, SIMD2<Double>(1.0, 1.0))
    }
}
