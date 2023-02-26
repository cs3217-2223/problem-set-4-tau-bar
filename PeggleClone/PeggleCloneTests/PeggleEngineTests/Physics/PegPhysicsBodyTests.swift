//
//  PegPhysicsBodyTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class PegPhysicsBodyTests: XCTest {
    var physicsBody: PegPhysicsBody?
    let ppbDelegate = MockPegPhysicsBodyDelegate()

    override func setUp() {
        super.setUp()
        physicsBody = PegPhysicsBody(circleOfRadius: 1.0,
                                     center: .zero,
                                     isDynamic: true, rotation: 0)
        physicsBody?.pegPhysicsBodyDelegate = ppbDelegate
    }

    func testInit() {
        guard let physicsBody = physicsBody else {
            return XCTFail("Peg Body is nil")
        }
        XCTAssertNotNil(physicsBody.pegPhysicsBodyDelegate)
    }

    func testCollide_withBall_shouldCallDelegate() {
        let ballBody = BallPhysicsBody(circleOfRadius: 2.0,
                                       center: .zero,
                                       isDynamic: true, rotation: 0)

        XCTAssertFalse(ppbDelegate.collidedWithBall)

        guard let didCollide = physicsBody?.collide(with: ballBody) else {
            return XCTFail("Didn't collide")
        }
        XCTAssertTrue(didCollide)

        XCTAssertTrue(ppbDelegate.collidedWithBall)
    }

    func testCollide_notWithBall_shouldNotCallDelegate() {
        let body = MSKCirclePhysicsBody(circleOfRadius: 2.0,
                                       center: .zero,
                                        isDynamic: true, rotation: 0)

        XCTAssertFalse(ppbDelegate.collidedWithBall)

        guard let didCollide = physicsBody?.collide(with: body) else {
            return XCTFail("Didn't collide")
        }
        XCTAssertTrue(didCollide)

        XCTAssertFalse(ppbDelegate.collidedWithBall)
    }
}
