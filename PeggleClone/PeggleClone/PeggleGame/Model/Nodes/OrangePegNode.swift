//
//  OrangePegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class OrangePegNode: PegNode {
    init(position: CGPoint) {
        super.init(position: position, image: UIImage(named: "peg-orange"))
    }

    override func didCollideWithBall() {
        super.didCollideWithBall()
        image = UIImage(named: "peg-orange-glow")
    }
}
