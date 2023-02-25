//
//  BluePegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class BluePegNode: PegNode {
    init(position: CGPoint, radius: Double, rotation: Double) {
        super.init(position: position, image: UIImage(named: "peg-blue"), radius: radius, rotation: rotation)
    }

    override func didCollideWithBall(ballBody: BallPhysicsBody) {
        image = UIImage(named: "peg-blue-glow")
        super.didCollideWithBall(ballBody: ballBody)
    }
}
