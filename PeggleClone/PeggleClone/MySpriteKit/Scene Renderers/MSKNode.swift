//
//  MSKNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import Foundation

/// Represents a node inside a `MSKScene`.
class MSKNode {
    /// The position of the node within the scene.
    var position: CGPoint

    /// The anticlockwise rotation of the node.
    var angle: Double

    /// The physics body of the node.
    var physicsBody: MSKPhysicsBody

    init(physicsBody: MSKPhysicsBody) {
        self.position = CGPoint(x: physicsBody.position.x,
                                y: physicsBody.position.y)
        self.physicsBody = physicsBody
        self.angle = physicsBody.angle
        self.physicsBody.delegate = self
    }

    /// Returns width of the node.
    func getWidth() -> Double {
        physicsBody.getWidth()
    }

    /// Returns height of the node.
    func getHeight() -> Double {
        physicsBody.getHeight()
    }

    func updateAngle(newAngle: Double) {
        angle = newAngle
        physicsBody.angle = newAngle
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
