//
//  MSKPhysicsBodyTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

final class MSKCirclePhysicsBodyTests: XCTestCase {
    var circlePhysicsBody: MSKCirclePhysicsBody?
    let position = SIMD2<Double>(x: 1.0, y: 2.0)
    let oldPosition = SIMD2<Double>(x: 0.0, y: 1.0)
    let acceleration = SIMD2<Double>(x: 1.0, y: 1.0)
    let defaultTestAccuracy: Double = 0.0000001

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

    func testGetWidth_returnsCorrectValue() {
        XCTAssertEqual(circlePhysicsBody?.getWidth(), 10)
    }

    func testGetHeight_returnsCorrectValue() {
        XCTAssertEqual(circlePhysicsBody?.getHeight(), 10)
    }

    func testCollide_withNonDynamicCircle_shouldChangePositionCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("circlePhysicsBody is nil.")
        }

        let otherCircle = MSKCirclePhysicsBody(delegate: nil,
                                               position: SIMD2<Double>(3, 0),
                                               isDynamic: false,
                                               radius: 2)
        XCTAssertTrue(circlePhysicsBody.collide(with: otherCircle))
        XCTAssertEqual(circlePhysicsBody.position.x, 0.4469223, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circlePhysicsBody.position.y, 2.5530777, accuracy: defaultTestAccuracy)
        XCTAssertEqual(otherCircle.position, SIMD2<Double>(3.0, 0))
    }

    func testCollide_withDynamicCircle_shouldChangePositionCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("circlePhysicsBody is nil.")
        }

        let otherCircle = MSKCirclePhysicsBody(delegate: nil,
                                               position: SIMD2<Double>(3, 0),
                                               isDynamic: true,
                                               radius: 2)
        XCTAssertTrue(circlePhysicsBody.collide(with: otherCircle))
        XCTAssertEqual(circlePhysicsBody.position.x, 0.4469223, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circlePhysicsBody.position.y, 2.5530777, accuracy: defaultTestAccuracy)
        XCTAssertEqual(otherCircle.position.x, 3.5530777, accuracy: defaultTestAccuracy)
        XCTAssertEqual(otherCircle.position.y, -0.5530777, accuracy: defaultTestAccuracy)
    }

    func testCollide_withNonDynamicPolygon_shouldChangePositionCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("circlePhysicsBody is nil.")
        }

        let polygonPosition = SIMD2<Double>(x: 1.0, y: 4.5)
        let vertices = [SIMD2<Double>(-3, -3),
                        SIMD2<Double>(3, -3),
                        SIMD2<Double>(3, 3),
                        SIMD2<Double>(-3, 3)]
        let polygon = MSKPolygonPhysicsBody(vertices: vertices,
                                            position: polygonPosition,
                                            isDynamic: false)
        XCTAssertTrue(circlePhysicsBody.collide(with: polygon))
        XCTAssertEqual(circlePhysicsBody.position.x, -2.9659848, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circlePhysicsBody.position.y, 1.3390025, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygon.position, polygonPosition)
    }

    func testCollide_withDynamicPolygon_shouldChangePositionCorrectly() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("circlePhysicsBody is nil.")
        }

        let polygonPosition = SIMD2<Double>(x: 1.0, y: 4.5)
        let vertices = [SIMD2<Double>(-3, -3),
                        SIMD2<Double>(3, -3),
                        SIMD2<Double>(3, 3),
                        SIMD2<Double>(-3, 3)]
        let polygon = MSKPolygonPhysicsBody(vertices: vertices,
                                            position: polygonPosition,
                                            isDynamic: true)
        XCTAssertTrue(circlePhysicsBody.collide(with: polygon))
        XCTAssertEqual(circlePhysicsBody.position.x, -2.9659848, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circlePhysicsBody.position.y, 1.3390025, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygon.position.x, 4.9659848, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygon.position.y, 5.1609975, accuracy: defaultTestAccuracy)
    }
}
