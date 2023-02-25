//
//  YellowPegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class PurplePegNode: PegNode {
    init(position: CGPoint, radius: Double, rotation: Double) {
        super.init(position: position, image: UIImage(named: "peg-purple"), radius: radius, rotation: rotation)
    }

    override func didCollideWithBall(ballBody: BallPhysicsBody) {
        image = UIImage(named: "peg-purple-glow")
        delegate?.didTurnIntoBall(pegNode: self)
        super.didCollideWithBall(ballBody: ballBody)
    }
}
