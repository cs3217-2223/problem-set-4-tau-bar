//
//  MSKMocks.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

class MockMSKSceneDelegate: MSKSceneDelegate {
    var isNodeRemoved = false
    var isNodeAdded = false
    var isNodeUpdated = false
    var isNodeRotated = false

    func didRemoveNode(_ removedNode: MSKSpriteNode) {
        isNodeRemoved = true
    }

    func didAddNode(_ addedNode: MSKSpriteNode) {
        isNodeAdded = true
    }

    func didUpdateNode(_ node: MSKSpriteNode) {
        isNodeUpdated = true
    }

    func didRotateNode(_ node: MSKSpriteNode) {
        isNodeRotated = true
    }
}

class MockPhysicsWorld: MSKPhysicsWorld {
    var isPhysicsSimulated = false

    init() {
        super.init(bodies: [],
                   gravity: SIMD2<Double>(0, 1.0),
                   width: 500,
                   height: 500,
                   substeps: 2)
    }

    override func simulatePhysics(timeInterval: TimeInterval) {
        isPhysicsSimulated = true
    }
}

class MockPhysicsBodyDelegate: MSKPhysicsBodyDelegate {
    var isPositionUpdated = false

    func didUpdatePosition() {
        isPositionUpdated = true
    }
}

class MockMSKScene: MSKScene {
    var isUpdated = false

    init() {
        let physicsWorld: MSKPhysicsWorld = MockPhysicsWorld()
        super.init(physicsWorld: physicsWorld)
    }

    override func update(timeInterval: TimeInterval) {
        isUpdated = true
    }
}
