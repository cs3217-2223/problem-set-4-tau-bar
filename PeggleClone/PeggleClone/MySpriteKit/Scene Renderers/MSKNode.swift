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
    func updatePosition() {
        position.x = physicsBody.position.x
        position.y = physicsBody.position.y
    }
}

extension MSKNode: Equatable {
    static func ==(lhs: MSKNode, rhs: MSKNode) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension MSKNode: Hashable {
    public func hash(into hasher: inout Hasher) {
             hasher.combine(ObjectIdentifier(self))
    }
}
