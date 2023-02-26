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

        guard let bucketPos = bucket?.position else { return }
        boardSceneDelegates.forEach({ $0.didEnterBucket(gameState: gameState, at: bucketPos) })
    }

    func didChangeSpooky(ballNode: BallNode) {
        delegate?.didUpdateNodeImage(ballNode)
    }
}
