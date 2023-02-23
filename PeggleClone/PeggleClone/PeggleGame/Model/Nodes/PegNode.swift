//
//  PegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import UIKit

class PegNode: BoardObjectNode {
    weak var delegate: PegNodeDelegate?
    var isHit = false
    init(position: CGPoint, image: UIImage?, radius: Double, rotation: Double) {
        let pegPhysicsBody = PegPhysicsBody(circleOfRadius: radius,
                                            center: SIMD2<Double>(x: position.x, y: position.y),
                                            isDynamic: false, rotation: rotation)

        super.init(physicsBody: pegPhysicsBody,
                   image: image)
        pegPhysicsBody.pegPhysicsBodyDelegate = self
    }
}
