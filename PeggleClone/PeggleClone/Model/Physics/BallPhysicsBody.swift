//
//  BallPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import Foundation

class BallPhysicsBody: MSKCirclePhysicsBody {
    weak var ballPhysicsBodyDelegate: BallPhysicsBodyDelegate?

    override func collide(with body: MSKPhysicsBody) -> Bool {
        guard let body = body as? PegPhysicsBody else {
            return super.collide(with: body)
        }

        let didCollideWithBall = self.collide(with: body)

        if isStationary() {
            ballPhysicsBodyDelegate?.handleBallStuck()
        }

        return didCollideWithBall
    }

    func collide(with body: BallPhysicsBody) -> Bool {
        if super.collide(with: body) {
            return true
        } else {
            return false
        }
    }

    func isStationary() -> Bool {
        areApproxEqual(position, positionLast) && acceleration.x == 0
    }
}
