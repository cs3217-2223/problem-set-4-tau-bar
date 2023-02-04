//
//  SquareNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 4/2/23.
//

import Foundation
import UIKit

// TODO: Remove class, just for testing polygon collision physics
class SquareNode: MSKSpriteNode {
    init(physicsBody: MSKPolygonPhysicsBody) {
        super.init(physicsBody: physicsBody,
                   image: UIImage(named: "black"))
    }
}
