//
//  MSKPhysicsWorld.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import Foundation

class MSKPhysicsWorld {
    // MARK: Variables and Properties
    /// The physics bodies which are within the physics world.
    private var bodies: [MSKPhysicsBody]
    var width: Double
    var height: Double
    /// A vector that specifies the gravitational acceleration applied to physics bodies in the physics world.
    var gravity: SIMD2<Double>
    private var substeps: Int
    init(bodies: [MSKPhysicsBody] = [],
         gravity: SIMD2<Double> = defaultGravity,
         width: Double,
         height: Double,
         substeps: Int = 1) {
        self.bodies = bodies
        self.gravity = gravity
        self.substeps = substeps
        self.width = width
        self.height = height
    }
    func addBody(_ addedBody: MSKPhysicsBody) {
        bodies.append(addedBody)
    }
    func removeBody(_ removedBody: MSKPhysicsBody) {
        bodies.removeAll(where: { body in body === removedBody })
    }
    func simulatePhysics(dt: TimeInterval) {
        for _ in 0..<substeps {
            applyGravity()
            handleCollisions(dt: dt)
            applyConstraint()
            updateObjects(dt: dt)
        }
    }
    private func applyGravity() {
        for body in bodies {
            body.applyGravity(gravity)
        }
    }
    func resolveCollision(bodyA: MSKPhysicsBody, bodyB: MSKPhysicsBody) {
        bodyA.collide(with: bodyB)
        bodyB.collide(with: bodyA)
    }
    private func handleCollisions(dt: TimeInterval) {
        for idx1 in 0..<bodies.count {
            let bodyA = bodies[idx1]
            for idx2 in (idx1 + 1)..<bodies.count {
                let bodyB = bodies[idx2]
                resolveCollision(bodyA: bodyA, bodyB: bodyB)
            }
        }
    }
    func applyConstraint() {
        for body in bodies {
            // TODO: Add method for each physics body type to apply constraint to itself.
//            if body.position.x - body.radius < 0 {
//                body.positionLast = body.position
//                body.position.x = body.radius
//            }
//            if body.position.x + body.radius > width {
//                body.positionLast = body.position
//                body.position.x = width - body.radius
//            }
//            if body.position.y - body.radius < 0 {
//                body.positionLast = body.position
//                body.position.y = body.radius
//            }
//            if body.position.y + body.radius > width {
//                body.positionLast = body.position
//                body.position.y = width - body.radius
//            }
        }
    }
    private func updateObjects(dt: TimeInterval) {
        for body in bodies {
            body.updatePosition(dt: dt)
        }
    }
}
