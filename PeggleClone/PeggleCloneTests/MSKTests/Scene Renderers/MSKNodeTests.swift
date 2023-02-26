//
//  MSKNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class MSKNodeTests: XCTestCase {
    var node: MSKNode?
    let physicsBody = MSKCirclePhysicsBody(circleOfRadius: 1.0, center: .zero, isDynamic: true, rotation: 0)
    let defaultTimeInterval: Double = 0.1

    override func setUp() {
        super.setUp()
        node = MSKNode(physicsBody: physicsBody)
        physicsBody.delegate = node
    }

    func testInit() {
        guard let node = node else {
            return XCTFail("Node is nil")
        }

        XCTAssertNotNil(node.physicsBody)
        XCTAssertEqual(node.position.x, physicsBody.position.x)
        XCTAssertEqual(node.position.y, physicsBody.position.y)
        XCTAssertEqual(node.angle, physicsBody.angle)
    }

    func testGetWidth_shouldEqualPhysicsBodyWidth() {
        let expectedWidth = physicsBody.getWidth()

        XCTAssertEqual(node?.getWidth(), expectedWidth)
    }

    func testGetHeight_shouldEqualPhysicsBodyHeight() {
        let expectedHeight = physicsBody.getHeight()

        XCTAssertEqual(node?.getHeight(), expectedHeight)
    }

    func testDidUpdatePositon_whenUpdatePhysicsBodyPosition_shouldUpdateNodePosition() {
        let originalPosition = physicsBody.position
        guard let nodePosition = node?.position else {
            return XCTFail("position is nil")
        }

        XCTAssertEqual(Double(nodePosition.x), originalPosition.x)
        XCTAssertEqual(Double(nodePosition.y), originalPosition.y)

        let displacement = SIMD2<Double>(0.0, 1.0)
        physicsBody.updatePosition(by: displacement)
        physicsBody.updatePosition(timeInterval: defaultTimeInterval)

        // Node position should be updated via didUpdatePosition
        let expectedNewPosition = physicsBody.position
        guard let nodePosition = node?.position else {
            return XCTFail("position is nil")
        }

        XCTAssertEqual(Double(nodePosition.x), expectedNewPosition.x)
        XCTAssertEqual(Double(nodePosition.y), expectedNewPosition.y)
    }

    func testUpdateAngle_shouldUpdateNodeAngle() {
        let newAngle = 0.9
        let originalAngle = node?.angle

        node?.updateAngle(newAngle: newAngle)

        XCTAssertEqual(node?.angle, newAngle)
        XCTAssertNotEqual(node?.angle, originalAngle)
    }
}
