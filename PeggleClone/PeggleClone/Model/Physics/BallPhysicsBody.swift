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
        let didCollideWithBall = super.collide(with: body)

        if isStationary() {
            ballPhysicsBodyDelegate?.handleBallStuck()
        }

        return didCollideWithBall
    }

    func isStationary() -> Bool {
        areApproxEqual(position, positionLast) && acceleration.x == 0
    }
}
