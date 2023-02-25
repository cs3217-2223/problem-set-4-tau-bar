//
//  BucketBasePhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class BucketBasePhysicsBody: MSKPolygonPhysicsBody {
    weak var bucketBaseDelegate: BucketBasePhysicsBodyDelegate?
    override func collide(with body: MSKPhysicsBody) -> Bool {
        guard let body = body as? BallPhysicsBody else {
            return super.collide(with: body)
        }

        let didCollideWithBall = self.collide(with: body)

        return didCollideWithBall
    }

    func collide(with body: BallPhysicsBody) -> Bool {
        if super.collide(with: body) {
            bucketBaseDelegate?.didBallCollideWithBucketBase(ball: body)
            return true
        } else {
            return false
        }
    }
}
