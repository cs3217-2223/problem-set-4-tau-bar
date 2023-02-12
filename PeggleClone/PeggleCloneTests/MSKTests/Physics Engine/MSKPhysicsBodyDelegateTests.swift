//
//  MSKPhysicsBodyDelegateTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

final class MSKPhysicsBodyDelegateTests: XCTestCase {
    var circlePhysicsBody: MSKCirclePhysicsBody?
    let position = SIMD2<Double>(x: 1.0, y: 2.0)
    let oldPosition = SIMD2<Double>(x: 0.0, y: 1.0)
    let acceleration = SIMD2<Double>(x: 1.0, y: 1.0)
    let defaultTestAccuracy: Double = 0.0000001
    let defaultTimeInterval: Double = 0.1
    let delegate = MockPhysicsBodyDelegate()

    override func setUp() {
        super.setUp()
        circlePhysicsBody = MSKCirclePhysicsBody(delegate: delegate,
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

    func testUpdatePosition_callsDidUpdatePosition() {
        guard let circlePhysicsBody = circlePhysicsBody else {
            return XCTFail("Body is nil")
        }

        XCTAssertFalse(delegate.isPositionUpdated)

        circlePhysicsBody.updatePosition(timeInterval: defaultTimeInterval)

        XCTAssertTrue(delegate.isPositionUpdated)
    }
}
