//
//  PegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import UIKit

class PegNode: BoardObjectNode, PegPhysicsBodyDelegate {
    weak var delegate: PegNodeDelegate?
    var isHit = false
    init(position: CGPoint, image: UIImage?, radius: Double, rotation: Double) {
        let pegPhysicsBody = PegPhysicsBody(circleOfRadius: radius,
                                            center: SIMD2<Double>(x: position.x, y: position.y),
                                            affectedByGravity: false,
                                            isDynamic: false, rotation: rotation)

        super.init(physicsBody: pegPhysicsBody,
                   image: image)
        pegPhysicsBody.pegPhysicsBodyDelegate = self
    }

    func didCollideWithBall(ballBody: BallPhysicsBody) {
        delegate?.didCollideWithBall(pegNode: self)
        if !isHit {
            isHit = true
            delegate?.didHitBallFirstTIme(pegNode: self)
        }
    }
}
