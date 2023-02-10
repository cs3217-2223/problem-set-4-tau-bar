//
//  BallNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//
import UIKit

class BallNode: MSKSpriteNode {
    init(oldPosition: CGPoint, position: CGPoint) {
        let defaultPhysicsBody = BallPhysicsBody(circleOfRadius: 20.0,
                                                 oldPosition: SIMD2<Double>(x: oldPosition.x, y: oldPosition.y),
                                                 position: SIMD2<Double>(x: position.x, y: position.y),
                                                 isDynamic: true)
        super.init(physicsBody: defaultPhysicsBody,
                   image: UIImage(named: "ball"))
    }
}
