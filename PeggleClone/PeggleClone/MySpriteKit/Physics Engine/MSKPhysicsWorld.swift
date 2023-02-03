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
            checkCollisions(dt: dt)
            applyConstraint()
            updateObjects(dt: dt)
        }
    }
    private func applyGravity() {
        for body in bodies {
            body.applyGravity(gravity)
        }
    }
    private func checkCollisions(dt: TimeInterval) {
        let responseCoeff: Double = defaultResponseCoeff
        for idx1 in 0..<bodies.count {
            let bodyA = bodies[idx1]
            for idx2 in (idx1 + 1)..<bodies.count {
                let bodyB = bodies[idx2]
                let minDistance = bodyA.radius + bodyB.radius
                let collisionAxis = bodyA.position - bodyB.position
                let collisionAxisLength = getLength(of: collisionAxis)
                // Checks whether the objects are overlapping.
                if collisionAxisLength < minDistance {
                    let unitVector = collisionAxis / collisionAxisLength
                    let massRatioA = bodyA.mass / (bodyA.mass + bodyB.mass)
                    let massRatioB = bodyB.mass / (bodyA.mass + bodyB.mass)
                    let delta = 0.5 * responseCoeff * (collisionAxisLength - minDistance)
                    // Update positions of both bodies.
                    bodyA.updatePosition(by: -1 * unitVector * (massRatioB * delta))
                    bodyB.updatePosition(by: unitVector * (massRatioA * delta))
                }
            }
        }
    }
    
    func applyConstraint() {
        for body in bodies {
            if body.position.x - body.radius < 0 {
                body.positionLast = body.position
                body.position.x = body.radius
            }
            if body.position.x + body.radius > width {
                body.positionLast = body.position
                body.position.x = width - body.radius
            }
            if body.position.y - body.radius < 0 {
                body.positionLast = body.position
                body.position.y = body.radius
            }
            if body.position.y + body.radius > width {
                body.positionLast = body.position
                body.position.y = width - body.radius
            }
        }
    }
    private func updateObjects(dt: TimeInterval) {
        for body in bodies {
            body.updatePosition(dt: dt)
        }
    }
    private func getLength(of vector: SIMD2<Double>) -> Double {
        sqrt(vector.x * vector.x + vector.y * vector.y)
    }
}
