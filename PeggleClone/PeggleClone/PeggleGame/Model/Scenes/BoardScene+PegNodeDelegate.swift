//
//  BoardScene+PegNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension BoardScene: PegNodeDelegate {
    func didCollideWithBall(pegNode: PegNode) {
        boardSceneDelegate?.didCollideWithBall(updatedPegNode: pegNode)
        gameState.didCollideWithBall(pegNode: pegNode)
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
}
