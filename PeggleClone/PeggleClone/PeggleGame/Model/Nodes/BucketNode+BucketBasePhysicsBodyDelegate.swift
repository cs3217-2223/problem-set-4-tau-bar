//
//  BucketNode+BucketBasePhysicsBodyDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

extension BucketNode: BucketBasePhysicsBodyDelegate {
    func didBallCollideWithBucketBase() {
        bucketDelegate?.didEnterBucket()
    }
}
