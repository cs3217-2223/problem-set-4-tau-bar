//
//  PeggleMocks.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

class MockPegNodeDelegate: PegNodeDelegate {
    var hasCollidedWithBall = false

    func didCollideWithBall(pegNode: PegNode) {
        hasCollidedWithBall = true
    }
}

class MockBallNodeDelegate: BallNodeDelegate {
    var didCallHandleBallStuck = false
    func handleBallStuck() {
        didCallHandleBallStuck = true
    }
}

class MockPegPhysicsBodyDelegate: PegPhysicsBodyDelegate {
    var collidedWithBall = false

    func didCollideWithBall() {
        collidedWithBall = true
    }
}

class MockBallPhysicsBodyDelegate: BallPhysicsBodyDelegate {
    var didCallHandleBallStuck = false

    func handleBallStuck() {
        didCallHandleBallStuck = true
    }
}

class MockBoardSceneDelegate: BoardSceneDelegate {
    var hasCollidedWithBall = false
    var isPegNodeRemoved = false

    func didCollideWithBall(updatedPegNode: PegNode) {
        hasCollidedWithBall = true
    }

    func didRemovePegNode(removedNode: PegNode) {
        isPegNodeRemoved = true
    }
}
