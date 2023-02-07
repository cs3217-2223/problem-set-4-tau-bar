//
//  CannonNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import UIKit

class CannonNode: MSKSpriteNode {
    init(center: SIMD2<Double>) {
        let vertices = getVerticesForRect(width: 100, height: 100)
        let cannonPb = MSKPolygonPhysicsBody(vertices: vertices, position: center, isDynamic: false)
        super.init(physicsBody: cannonPb, image: UIImage(named: "cannon"))
    }
}
