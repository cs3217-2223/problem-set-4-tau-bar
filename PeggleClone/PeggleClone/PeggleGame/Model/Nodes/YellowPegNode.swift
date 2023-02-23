//
//  YellowPegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class YellowPegNode: PegNode {
    init(position: CGPoint) {
        super.init(position: position, image: UIImage(named: "peg-yellow"))
    }

    override func didCollideWithBall() {
        image = UIImage(named: "peg-yellow-glow")
        super.didCollideWithBall()
    }
}
