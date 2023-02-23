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
    init(position: CGPoint) {
        let vertices = PhysicsUtil.getVerticesForRect(width: 40, height: 40)
        let pegPhysicsBody = MSKPolygonPhysicsBody(vertices: vertices,
                                                   position: SIMD2<Double>(position.x, position.y),
                                                   isDynamic: false)

        super.init(physicsBody: pegPhysicsBody,
                   image: UIImage(named: "black"))
    }
}
