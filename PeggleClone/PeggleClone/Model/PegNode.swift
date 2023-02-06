//
//  PegNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import UIKit

class PegNode: MSKSpriteNode, PegPhysicsBodyDelegate {
    weak var delegate: PegNodeDelegate?
    var isHit = false
    init(position: CGPoint, image: UIImage?) {
        let pegPhysicsBody = PegPhysicsBody(circleOfRadius: 20.0,
                       center: SIMD2<Double>(x: position.x, y: position.y),
                       isDynamic: true)
        super.init(physicsBody: pegPhysicsBody,
                   image: image)
        pegPhysicsBody.pegPhysicsBodyDelegate = self
    }

    func didCollideWithBall() {
        isHit = true
        delegate?.didCollideWithBall(pegNode: self)
    }
}
