//
//  CannonNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class CannonNode: MSKSpriteNode {
    static let defaultCannonRadius: Double = 50
    
    init(center: SIMD2<Double>) {
        let cannonPb = MSKCirclePhysicsBody(position: center,
                                            isDynamic: false,
                                            categoryBitMask: 0,
                                            radius: CannonNode.defaultCannonRadius)
        super.init(physicsBody: cannonPb, image: UIImage(named: "cannon"))
    }

}
