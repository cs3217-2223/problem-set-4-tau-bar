//
//  BoardScene+PegNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension BoardScene: PegNodeDelegate {
    func didHitBallFirstTIme(pegNode: PegNode) {
        boardSceneDelegates.forEach({ $0.didHitBallFirstTime(pegNode: pegNode) })
    }

    func didCollideWithBall(pegNode: PegNode) {
        gameState.didCollideWithBall(pegNode: pegNode)
        boardSceneDelegates.forEach({ $0.didCollideWithBall(updatedPegNode: pegNode) })
    }

    func didActivatePower(pegNode: PegNode, ballBody: BallPhysicsBody) {
        let node = nodes.first(where: { ObjectIdentifier($0.physicsBody) == ObjectIdentifier(ballBody) })
        guard let ballNode = node as? BallNode else { return }
        fighter?.performPower(pegNode: pegNode, ballNode: ballNode)
    }

    func didGlow(pegNode: PegNode) {
        delegate?.didUpdateNodeImage(pegNode)
    }

    func didTurnIntoBall(pegNode: PegNode) {
        removeNode(pegNode)
        let oldPosition = CGPoint(x: pegNode.physicsBody.positionLast.x, y: pegNode.physicsBody.positionLast.y)
        let ballNode = BallNode(oldPosition: oldPosition, position: pegNode.position)
        addBallNode(ballNode)
    }

    func didUpsideDown(pegNode: PegNode) {
        for node in nodes where !PeggleGameConstants.nonUpsideDownNodes.contains(where: { type(of: node) == $0 }) {
            let flippedY = physicsWorld.height - node.position.y
            let flippedX = physicsWorld.width - node.position.x
            node.physicsBody.move(to: SIMD2<Double>(flippedX, flippedY))
        }
    }

}
