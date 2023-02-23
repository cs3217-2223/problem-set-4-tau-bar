//
//  RedPegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class RedPegNode: PegNode {
    init(position: CGPoint) {
        super.init(position: position, image: UIImage(named: "peg-red"))
    }

    override func didCollideWithBall() {
        image = UIImage(named: "peg-pink-glow")
        super.didCollideWithBall()
    }
}
