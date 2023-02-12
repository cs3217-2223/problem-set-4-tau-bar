//
//  MSKPolygonPhysicsBodyTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

final class MSKPolygonPhysicsBodyTests: XCTestCase {
    var polygonPhysicsBody: MSKPolygonPhysicsBody?
    let positionLast = SIMD2<Double>(x: 1, y: 2)
    let position = SIMD2<Double>(x: 3, y: 3)
    let acceleration = SIMD2<Double>(x: 1.0, y: 1.0)
    let vertices = [SIMD2<Double>(x: 3, y: 3),
                    SIMD2<Double>(x: 3, y: -3),
                    SIMD2<Double>(x: -3, y: -3),
                    SIMD2<Double>(x: -3, y: 3)]
    let angle = 0.5
    let defaultTestAccuracy: Double = 0.0000001

    override func setUp() {
        super.setUp()

        polygonPhysicsBody = MSKPolygonPhysicsBody(delegate: nil,
                                         positionLast: positionLast,
                                         position: position,
                                         acceleration: acceleration,
                                         vertices: vertices,
                                         angle: angle)
    }

    func testInit() {
        guard let polygonPhysicsBody = polygonPhysicsBody else {
            return XCTFail("polygonPhysicsBody is nil.")
        }

        XCTAssertEqual(polygonPhysicsBody.positionLast, positionLast)
        XCTAssertEqual(polygonPhysicsBody.position, position)
        XCTAssertEqual(polygonPhysicsBody.acceleration, acceleration)
        XCTAssertEqual(polygonPhysicsBody.affectedByGravity, true)
        XCTAssertEqual(polygonPhysicsBody.isDynamic, true)
        XCTAssertEqual(polygonPhysicsBody.categoryBitMask, 0xFFFFFFFF)
        XCTAssertEqual(polygonPhysicsBody.mass, 1.0)
        XCTAssertEqual(polygonPhysicsBody.vertices, vertices)
        XCTAssertEqual(polygonPhysicsBody.angle, 0.5)
    }

    func testGetWidth_returnsCorrectValue() {
        XCTAssertEqual(polygonPhysicsBody?.getWidth(), 6)
    }

    func testGetHeight_returnsCorrectValue() {
        XCTAssertEqual(polygonPhysicsBody?.getHeight(), 6)
    }

    func testCollide_withNonDynamicCircle_shouldChangePositionCorrectly() {
        guard let polygonPhysicsBody = polygonPhysicsBody else {
            return XCTFail("polygonPhysicsBody is nil.")
        }

        let circle = MSKCirclePhysicsBody(delegate: nil,
                                          position: SIMD2<Double>(3, 2.5),
                                               isDynamic: false,
                                               radius: 2)
        XCTAssertTrue(polygonPhysicsBody.collide(with: circle))
        XCTAssertEqual(polygonPhysicsBody.position.x, 0.7317787, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygonPhysicsBody.position.y, 4.8901844, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circle.position, SIMD2<Double>(3.0, 2.5))
    }

    func testCollide_withDynamicCircle_shouldChangePositionCorrectly() {
        guard let polygonPhysicsBody = polygonPhysicsBody else {
            return XCTFail("polygonPhysicsBody is nil.")
        }

        let circle = MSKCirclePhysicsBody(delegate: nil,
                                          position: SIMD2<Double>(3, 2.5),
                                               isDynamic: true,
                                               radius: 2)
        XCTAssertTrue(polygonPhysicsBody.collide(with: circle))
        XCTAssertEqual(polygonPhysicsBody.position.x, 0.7317787, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygonPhysicsBody.position.y, 4.8901844, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circle.position.x, 5.2682213, accuracy: defaultTestAccuracy)
        XCTAssertEqual(circle.position.y, 0.6098156, accuracy: defaultTestAccuracy)
    }

    func testCollide_withNonDynamicPolygon_shouldChangePositionCorrectly() {
        guard let polygonPhysicsBody = polygonPhysicsBody else {
            return XCTFail("polygonPhysicsBody is nil.")
        }

        let polygonPosition = SIMD2<Double>(x: 1.0, y: 4.5)
        let vertices = [SIMD2<Double>(-3, -3),
                        SIMD2<Double>(3, -3),
                        SIMD2<Double>(3, 3),
                        SIMD2<Double>(-3, 3)]
        let polygon = MSKPolygonPhysicsBody(vertices: vertices,
                                            position: polygonPosition,
                                            isDynamic: false)
        XCTAssertTrue(polygonPhysicsBody.collide(with: polygon))
        XCTAssertEqual(polygonPhysicsBody.position.x, 5.0, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygonPhysicsBody.position.y, 3.0, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygon.position, polygonPosition)
    }

    func testCollide_withDynamicPolygon_shouldChangePositionCorrectly() {
        guard let polygonPhysicsBody = polygonPhysicsBody else {
            return XCTFail("polygonPhysicsBody is nil.")
        }

        let polygonPosition = SIMD2<Double>(x: 1.0, y: 4.5)
        let vertices = [SIMD2<Double>(-3, -3),
                        SIMD2<Double>(3, -3),
                        SIMD2<Double>(3, 3),
                        SIMD2<Double>(-3, 3)]
        let polygon = MSKPolygonPhysicsBody(vertices: vertices,
                                            position: polygonPosition,
                                            isDynamic: true)
        XCTAssertTrue(polygonPhysicsBody.collide(with: polygon))
        XCTAssertEqual(polygonPhysicsBody.position.x, 5.0, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygonPhysicsBody.position.y, 3.0, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygon.position.x, -1.0, accuracy: defaultTestAccuracy)
        XCTAssertEqual(polygon.position.y, 4.5, accuracy: defaultTestAccuracy)
    }
}
