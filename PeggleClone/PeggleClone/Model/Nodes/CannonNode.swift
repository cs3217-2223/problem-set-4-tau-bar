//
//  CannonNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class CannonNode: MSKSpriteNode {
    init(center: SIMD2<Double>) {
        let cannonPb = MSKCirclePhysicsBody(position: center,
                                            isDynamic: false,
                                            categoryBitMask: 0,
                                            radius: defaultCannonRadius)
        super.init(physicsBody: cannonPb, image: UIImage(named: "cannon"))
    }

}
