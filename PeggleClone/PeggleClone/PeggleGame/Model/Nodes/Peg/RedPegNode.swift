//
//  RedPegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class RedPegNode: PegNode {
    init(position: CGPoint, radius: Double, rotation: Double) {
        super.init(position: position, image: UIImage(named: "peg-red"), radius: radius, rotation: rotation)
    }

    override func didCollideWithBall(ballBody: BallPhysicsBody) {
        image = UIImage(named: "peg-red-glow")
        if !isHit {
            delegate?.didUpsideDown(pegNode: self)
        }
        super.didCollideWithBall(ballBody: ballBody)
    }
}
