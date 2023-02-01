//
//  MSKNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import Foundation

class MSKNode {
    var position: CGPoint
    var physicsBody: MSKPhysicsBody
    init(position: CGPoint, physicsBody: MSKPhysicsBody) {
        self.position = position
        self.physicsBody = physicsBody
    }
}
