//
//  CannonNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class CannonNode: MSKSpriteNode {
    init(center: SIMD2<Double>) {
        let cannonPb = MSKCirclePhysicsBody(circleOfRadius: 50, center: center, isDynamic: false)
        super.init(physicsBody: cannonPb, image: UIImage(named: "cannon"))
    }

}
