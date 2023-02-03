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
        super.init(position: position,
                   physicsBody: MSKPhysicsBody(circleOfRadius: 1.0,
                                               center: SIMD2<Double>(x: position.x,
                                                                     y: position.y)),
                   image: UIImage(named: "peg-blue"))
    }
    init(physicsBody: MSKPhysicsBody) {
        super.init(position: CGPoint(x: physicsBody.position.x,
                                     y: physicsBody.position.y),
                   physicsBody: physicsBody,
                   image: UIImage(named: "peg-blue"))
    }
}
