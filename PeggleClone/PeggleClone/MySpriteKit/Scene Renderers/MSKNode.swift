//
//  MSKNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import Foundation

/// Represents a node inside a `MSKScene`.
class MSKNode: MSKPhysicsBodyDelegate {
    /// The position of the node within the scene.
    var position: CGPoint

    /// The physics body of the node.
    var physicsBody: MSKPhysicsBody

    init(physicsBody: MSKPhysicsBody) {
        self.position = CGPoint(x: physicsBody.position.x,
                                y: physicsBody.position.y)
        self.physicsBody = physicsBody
        self.physicsBody.delegate = self
    }

    /// Updates position of node when position of physics body gets updated.
    /// Delegate function for `MSKPhysicsBodyDelegate`.
    func didUpdatePosition() {
        updatePosition()
    }

    private func updatePosition() {
        position.x = physicsBody.position.x
        position.y = physicsBody.position.y
    }
}

extension MSKNode: Equatable {
    static func == (lhs: MSKNode, rhs: MSKNode) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension MSKNode: Hashable {
    public func hash(into hasher: inout Hasher) {
             hasher.combine(ObjectIdentifier(self))
    }
}
