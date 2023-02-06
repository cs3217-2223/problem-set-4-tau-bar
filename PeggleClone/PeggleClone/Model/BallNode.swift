//
//  BallNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//
import UIKit

class BallNode: MSKSpriteNode {
    init(position: CGPoint) {
        super.init(physicsBody: BallPhysicsBody(circleOfRadius: 20.0,
                                                     center: SIMD2<Double>(x: position.x,
                                                                     y: position.y),
                                                     isDynamic: true),
                   image: UIImage(named: "ball"))
    }
}
