//
//  PegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import UIKit

class PegNode: MSKSpriteNode {
    // TODO: Create Blue, Orange peg classes, etc.
    init(position: CGPoint) {
        super.init(physicsBody: MSKCirclePhysicsBody(circleOfRadius: 20.0,
                                               center: SIMD2<Double>(x: position.x,
                                                                     y: position.y)),
                   image: UIImage(named: "peg-blue"))
    }
    init(physicsBody: MSKCirclePhysicsBody) {
        super.init(physicsBody: physicsBody,
                   image: UIImage(named: "peg-blue"))
    }
}
