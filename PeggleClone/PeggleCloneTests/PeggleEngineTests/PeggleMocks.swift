//
//  PeggleMocks.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

class MockPegNodeDelegate: PegNodeDelegate {
    var hasCollidedWithBall = false
    var hitBallFirstTime = false
    var activatePower = false
    var glow = false
    var turnIntoBall = false
    var upsideDown = false

    func didCollideWithBall(pegNode: PegNode) {
        hasCollidedWithBall = true
    }
    
    func didHitBallFirstTIme(pegNode: PegNode) {
        hitBallFirstTime = true
    }
    
    func didActivatePower(pegNode: PegNode, ballBody: BallPhysicsBody) {
        activatePower = true
    }
    
    func didGlow(pegNode: PegNode) {
        glow = true
    }
    
    func didTurnIntoBall(pegNode: PegNode) {
        turnIntoBall = true
    }
    
    func didUpsideDown(pegNode: PegNode) {
        upsideDown = true
    }
}

class MockBallNodeDelegate: BallNodeDelegate {

    
    var didCallHandleBallStuck = false
    var changeSpooky = false
    
    func handleBallStuck() {
        didCallHandleBallStuck = true
    }
    
    func didChangeSpooky(ballNode: BallNode) {
        changeSpooky = true
    }
}

class MockPegPhysicsBodyDelegate: PegPhysicsBodyDelegate {
    
    var collidedWithBall = false

    func didCollideWithBall(ballBody: BallPhysicsBody) {
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
    var hitBallFirstTime = false
    func didHitBallFirstTime(pegNode: PegNode) {
        hitBallFirstTime = true
    }
    
    var removeBoardNode = false
    func didRemoveBoardNode(removedNode: BoardObjectNode) {
        removeBoardNode = true
    }
    var addExplosion = false
    func didAddExplosion(at location: CGPoint, duration: TimeInterval, radius: Double) {
        addExplosion = true
    }
    var fireCannon = false
    func didFireCannon() {
        fireCannon = true
    }
    
    var enterBucket = false
    func didEnterBucket(gameState: GameState, at location: CGPoint) {
        enterBucket = true
    }
    
    var hasCollidedWithBall = false

    func didCollideWithBall(updatedPegNode: PegNode) {
        hasCollidedWithBall = true
    }
}
