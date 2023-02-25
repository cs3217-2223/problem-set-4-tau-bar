//
//  BallNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//
import UIKit

class BallNode: MSKSpriteNode {
    static let defaultImage = UIImage(named: "ball")
    static let spookyImage = UIImage(named: "peg-yellow")
    weak var delegate: BallNodeDelegate?
    var isSpooky = false {
        didSet {
            if isSpooky {
                image = BallNode.spookyImage
            } else {
                image = BallNode.defaultImage
            }
            delegate?.didChangeSpooky(ballNode: self)
        }
    }
    init(oldPosition: CGPoint, position: CGPoint) {
        let physicsBody = BallPhysicsBody(circleOfRadius: 20.0,
                                                 oldPosition: SIMD2<Double>(x: oldPosition.x, y: oldPosition.y),
                                                 position: SIMD2<Double>(x: position.x, y: position.y),
                                                 isDynamic: true)
        super.init(physicsBody: physicsBody,
                   image: BallNode.defaultImage)

        physicsBody.ballPhysicsBodyDelegate = self
    }
}
