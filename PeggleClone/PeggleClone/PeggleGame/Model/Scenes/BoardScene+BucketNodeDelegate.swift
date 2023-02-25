//
//  BoardScene+BucketNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

extension BoardScene: BucketNodeDelegate {
    func didEnterBucket(ball body: BallPhysicsBody) {
        gameState.didBallEnterBucket()
        guard let ballNode = nodes.first(where: {
            ObjectIdentifier($0.physicsBody) == ObjectIdentifier(body)
        }) as? BallNode else { return }
        handleResetBall(ballNode: ballNode)
    }

    func didChangeSpooky(ballNode: BallNode) {
        delegate?.didUpdateNodeImage(ballNode)
    }
}
