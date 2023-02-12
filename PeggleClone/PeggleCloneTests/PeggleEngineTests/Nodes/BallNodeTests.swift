//
//  BallNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class BallNodeTests: XCTestCase {
    var ballNode: BallNode?
    let delegate = MockBallNodeDelegate()

    override func setUp() {
        super.setUp()
        ballNode = BallNode(oldPosition: .zero, position: .zero)
        ballNode?.delegate = delegate
    }

    func testInit() {
        guard let ballNode = ballNode else {
            return XCTFail("Ball Node is nil")
        }
        XCTAssertNotNil(ballNode.delegate)
    }

    func testHandleBallStuck_shouldCallDelegate() {
        guard let ballNode = ballNode else {
            return XCTFail("Ball Node is nil")
        }

        XCTAssertFalse(delegate.didCallHandleBallStuck)

        ballNode.handleBallStuck()

        XCTAssertTrue(delegate.didCallHandleBallStuck)
    }

}
