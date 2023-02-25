//
//  PegPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import Foundation

class PegPhysicsBody: MSKCirclePhysicsBody {
    weak var pegPhysicsBodyDelegate: PegPhysicsBodyDelegate?

    override func collide(with body: MSKPhysicsBody) -> Bool {
        guard let body = body as? BallPhysicsBody else {
            return super.collide(with: body)
        }

        let didCollideWithBall = self.collide(with: body)

        return didCollideWithBall
    }

    func collide(with body: BallPhysicsBody) -> Bool {
        if super.collide(with: body) {
            pegPhysicsBodyDelegate?.didCollideWithBall(ballBody: body)
            return true
        } else {
            return false
        }
    }
}
