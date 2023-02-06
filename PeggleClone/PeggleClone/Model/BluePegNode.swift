//
//  BluePegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class BluePegNode: PegNode {
    init(position: CGPoint) {
        super.init(position: position, image: UIImage(named: "peg-blue"))
    }

    override func didCollideWithBall() {
        image = UIImage(named: "peg-blue-glow")
        super.didCollideWithBall()
    }
}
