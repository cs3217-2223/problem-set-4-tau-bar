//
//  BlockNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class BlockNode: BoardObjectNode {
    weak var delegate: PegNodeDelegate?
    var isHit = false
    init(position: CGPoint, width: Double, height: Double, rotation: Double) {
        let vertices = PhysicsUtil.getVerticesForRect(width: width, height: height)
        let blockPhysicsBody = MSKPolygonPhysicsBody(vertices: vertices,
                                                   position: SIMD2<Double>(position.x, position.y),
                                                   isDynamic: false,
                                                   rotation: rotation)

        super.init(physicsBody: blockPhysicsBody,
                   image: UIImage(named: "black"))
    }
}
