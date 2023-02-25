//
//  BucketNode+BucketBasePhysicsBodyDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

extension BucketNode: BucketBasePhysicsBodyDelegate {
    func didBallCollideWithBucketBase(ball body: BallPhysicsBody) {
        bucketDelegate?.didEnterBucket(ball: body)
    }
}
