//
//  BallPhysicsBodyTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class BallPhysicsBodyTests: XCTest {
    var physicsBody: BallPhysicsBody?
    let bpbDelegate = MockBallPhysicsBodyDelegate()

    override func setUp() {
        super.setUp()
        physicsBody = BallPhysicsBody(circleOfRadius: 1.0,
                                     center: .zero,
                                     isDynamic: true)
        physicsBody?.ballPhysicsBodyDelegate = bpbDelegate
    }

    func testInit() {
        guard let physicsBody = physicsBody else {
            return XCTFail("Ball Node is nil")
        }
        XCTAssertNotNil(physicsBody.ballPhysicsBodyDelegate)
    }

    func testCollide_ballStationary_shouldCallDelegate() {
        let body = MSKCirclePhysicsBody(circleOfRadius: 1.0,
                                        center: SIMD2<Double>(0.0, 2.0),
                                        isDynamic: false)

        XCTAssertFalse(bpbDelegate.didCallHandleBallStuck)

        guard let didCollide = physicsBody?.collide(with: body) else {
            return XCTFail("Did not collide")
        }

        XCTAssertTrue(didCollide)
        XCTAssertTrue(bpbDelegate.didCallHandleBallStuck)

    }
}
