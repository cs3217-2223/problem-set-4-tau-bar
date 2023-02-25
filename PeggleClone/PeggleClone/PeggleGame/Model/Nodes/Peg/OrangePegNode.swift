//
//  OrangePegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class OrangePegNode: PegNode {
    init(position: CGPoint, radius: Double, rotation: Double) {
        super.init(position: position, image: UIImage(named: "peg-orange"), radius: radius, rotation: rotation)
    }

    override func didCollideWithBall(ballBody: BallPhysicsBody) {
        super.didCollideWithBall(ballBody: ballBody)
        image = UIImage(named: "peg-orange-glow")
    }
}
