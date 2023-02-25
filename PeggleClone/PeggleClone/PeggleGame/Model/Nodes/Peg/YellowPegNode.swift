//
//  YellowPegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class YellowPegNode: PegNode {
    init(position: CGPoint, radius: Double, rotation: Double) {
        super.init(position: position, image: UIImage(named: "peg-purple"), radius: radius, rotation: rotation)
    }

    override func didCollideWithBall() {
        image = UIImage(named: "peg-purple-glow")
        super.didCollideWithBall()
    }
}
