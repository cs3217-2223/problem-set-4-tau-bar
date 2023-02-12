//
//  BoardSceneTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class BoardSceneTests: XCTestCase {
    var boardScene: BoardScene?
    let bsDelegate = MockBoardSceneDelegate()
    let pegNode: PegNode = BluePegNode(position: .zero)
    let ballNode = BallNode(oldPosition: .zero, position: .zero)

    override func setUp() {
        super.setUp()
        boardScene = BoardScene(width: 500, height: 500)
        boardScene?.boardSceneDelegate = bsDelegate
    }

    func testInit() {
        guard let boardScene = boardScene else {
            return XCTFail("Peg Node is nil")
        }
        XCTAssertNotNil(boardScene.boardSceneDelegate)
    }

    func testAddPegNode_shouldAddPegNode() {
        XCTAssertEqual(boardScene?.nodes.count, 0)

        boardScene?.addPegNode(pegNode)

        XCTAssertEqual(boardScene?.nodes.count, 1)
        guard let containsPegNode = boardScene?.nodes.contains(where: { $0 === pegNode }) else {
            return XCTFail("Board scene is nil")
        }
        XCTAssertTrue(containsPegNode)
    }

    func testAddBallNode_shouldAddBallNode() {
        XCTAssertEqual(boardScene?.nodes.count, 0)

        boardScene?.addBallNode(ballNode)

        XCTAssertEqual(boardScene?.nodes.count, 1)
        guard let containsBallNode = boardScene?.nodes.contains(where: { $0 === ballNode }) else {
            return XCTFail("Board scene is nil")
        }
        XCTAssertTrue(containsBallNode)
    }

    func testDidCollideWithBall_callsDelegateDidCollideWithBall() {
        XCTAssertFalse(bsDelegate.hasCollidedWithBall)

        boardScene?.didCollideWithBall(pegNode: pegNode)

        XCTAssertTrue(bsDelegate.hasCollidedWithBall)
    }

    func testSetupBoard_shouldAddCannonAndBorders() {
        boardScene?.setupBoard()

        XCTAssertEqual(boardScene?.nodes.count, 1)
        guard let hasCannonNode = boardScene?.nodes.contains(where: { $0 is CannonNode }) else {
            return XCTFail("Board scene is nil")
        }
        XCTAssertTrue(hasCannonNode)
        XCTAssertEqual(boardScene?.physicsWorld.bodiesCount, 4)
    }

    func testFireCannon() {
        boardScene?.setupBoard()
        let targetLocation = CGPoint(x: 100, y: 100)
        guard let hasBallNode = boardScene?.nodes.contains(where: { $0 is BallNode }) else {
            return XCTFail("Board scene is nil")
        }
        XCTAssertFalse(hasBallNode)

        boardScene?.fireCannon(at: targetLocation)

        // Check that a ball was created
        guard let hasBallNode = boardScene?.nodes.contains(where: { $0 is BallNode }) else {
            return XCTFail("Board scene is nil")
        }
        XCTAssertTrue(hasBallNode)
        XCTAssertEqual(boardScene?.nodes.count, 2)
    }

    func testHandleBallStuck_shouldRemoveHitPegs() {
        XCTAssertEqual(boardScene?.nodes.count, 0)
        let hitPegNode = BluePegNode(position: .zero)
        hitPegNode.isHit = true
        boardScene?.addPegNode(pegNode)
        boardScene?.addPegNode(hitPegNode)
        XCTAssertEqual(boardScene?.nodes.count, 2)

        boardScene?.handleBallStuck()

        XCTAssertEqual(boardScene?.nodes.count, 1)
        guard let hasPegNode = boardScene?.nodes.contains(where: { $0 === pegNode }) else {
            return XCTFail("Board scene is nil")
        }
        guard let hasHitPegNode = boardScene?.nodes.contains(where: { $0 === hitPegNode }) else {
            return XCTFail("Board scene is nil")
        }

        XCTAssertTrue(hasPegNode)
        XCTAssertFalse(hasHitPegNode)
        XCTAssertTrue(bsDelegate.isPegNodeRemoved)
    }

}
