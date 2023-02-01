//
//  MSKScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//
import Foundation

class MSKScene {
    /// The nodes which are part of the scene.
    var nodes: [MSKSpriteNode] = []
    /// The physics simulation associated with the scene.
    var physicsWorld: MSKPhysicsWorld
    init(physicsWorld: MSKPhysicsWorld) {
        self.physicsWorld = physicsWorld
    }
    /// Updates the scene with the current time interval.
    func update(dt: TimeInterval) {
        // TODO: Can replace this with Observer pattern.
        physicsWorld.simulatePhysics(dt: dt)
        didSimulatePhysics()
    }
    /// Runs once `physicsWorld` has completed physics simulation.
    func didSimulatePhysics() {
        updateNodePositions()
    }
    /// Update the node positions to equal the position of their respective physics bodies.
    func updateNodePositions() {
        for node in nodes {
            let physicsBodyPos = node.physicsBody.position
            node.position.x = physicsBodyPos.x
            node.position.y = physicsBodyPos.y
        }
    }
}
