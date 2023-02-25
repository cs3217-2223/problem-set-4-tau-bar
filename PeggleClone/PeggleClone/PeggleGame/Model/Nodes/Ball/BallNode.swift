//
//  BallNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//
import UIKit

class BallNode: MSKSpriteNode {
    weak var delegate: BallNodeDelegate?
    var isSpooky = false
    init(oldPosition: CGPoint, position: CGPoint) {
        let physicsBody = BallPhysicsBody(circleOfRadius: 20.0,
                                                 oldPosition: SIMD2<Double>(x: oldPosition.x, y: oldPosition.y),
                                                 position: SIMD2<Double>(x: position.x, y: position.y),
                                                 isDynamic: true)
        super.init(physicsBody: physicsBody,
                   image: UIImage(named: "ball"))

        physicsBody.ballPhysicsBodyDelegate = self
    }
}
