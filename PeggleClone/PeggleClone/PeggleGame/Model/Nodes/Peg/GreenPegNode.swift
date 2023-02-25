//
//  GreenPegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import UIKit

class GreenPegNode: PegNode {
    var isExploding: Bool = false
    init(position: CGPoint, radius: Double, rotation: Double) {
        super.init(position: position, image: UIImage(named: "peg-green"), radius: radius, rotation: rotation)
    }

    override func didCollideWithBall() {
        image = UIImage(named: "peg-green-glow")
        delegate?.didActivatePower(pegNode: self)
        super.didCollideWithBall()
    }
}
