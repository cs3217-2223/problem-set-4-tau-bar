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
    weak var delegate: MSKSceneDelegate?
    init(physicsWorld: MSKPhysicsWorld) {
        self.physicsWorld = physicsWorld
    }
    /// Adds a new node to the scene.
    func addNode(_ addedNode: MSKSpriteNode) {
        nodes.append(addedNode)
        physicsWorld.addBody(addedNode.physicsBody)
        delegate?.didAddNode(addedNode)
    }
    /// Removes a node from the scene.
    func removeNode(_ removedNode: MSKSpriteNode) {
        nodes.removeAll(where: { node in
            node == removedNode
        })
        delegate?.didRemoveNode(removedNode)
    }
    /// Updates the scene with the current time interval.
    func update(dt: TimeInterval) {
        // TODO: Can replace this with Observer pattern.
        physicsWorld.simulatePhysics(timeInterval: dt)
        didSimulatePhysics()
        // should update (remove, add) nodes here
    }
    /// Runs once `physicsWorld` has completed physics simulation.
    func didSimulatePhysics() {
        updateNodePositions()
    }
    /// Update the node positions to equal the position of their respective physics bodies.
    func updateNodePositions() {
        for node in nodes {
            node.updatePosition()
            delegate?.didMoveNode(node)
        }
    }
}
