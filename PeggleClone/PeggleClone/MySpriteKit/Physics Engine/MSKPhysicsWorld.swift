//
//  MSKPhysicsWorld.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import Foundation

/// Represents a physics world, containing bodies which interact with each other.
class MSKPhysicsWorld {
    // MARK: Variables and Properties
    /// The physics bodies which are within the physics world.
    private var bodies: [MSKPhysicsBody]

    /// The width of the physics world.
    var width: Double

    /// The height of the physics world.
    var height: Double

    /// A vector that specifies the gravitational acceleration applied to physics bodies in the physics world.
    var gravity: SIMD2<Double>

    /// Represents the number of substeps to apply physics within the specified time period.
    /// Greater number of substeps results in better-looking collisions & physics but poorer performance.
    /// Conversely, lower number of substeps results in worse-looking collisions & physics but better performance.
    private var substeps: Int

    /// Buffer for the border bodies, to allow collisions with borders to work properly.
    let borderBuffer: Double = 100

    // MARK: Initializers
    init(bodies: [MSKPhysicsBody] = [],
         gravity: SIMD2<Double> = defaultGravity,
         width: Double,
         height: Double,
         substeps: Int = 3) {
        self.bodies = bodies
        self.gravity = gravity
        self.substeps = substeps
        self.width = width
        self.height = height
    }

    // MARK: Methods

    func addTopBorder(xPos: Double, yPos: Double, width: Double) {
        let horizontalBorderVertices = getVerticesForRect(width: width + borderBuffer * 2, height: borderBuffer * 2)
        let topBorderPos = SIMD2<Double>(x: xPos, y: yPos - borderBuffer)
        let topBorder = MSKPolygonPhysicsBody(vertices: horizontalBorderVertices,
                                                 position: topBorderPos,
                                                 affectedByGravity: false,
                                                 isDynamic: false)
        addBody(topBorder)
    }

    func addLeftBorder(xPos: Double, yPos: Double, height: Double) {
        let verticalBorderVertices = getVerticesForRect(width: borderBuffer * 2, height: height + borderBuffer * 2)

        let leftBorderPos = SIMD2<Double>(x: xPos - borderBuffer, y: height / 2)
        let leftBorder = MSKPolygonPhysicsBody(vertices: verticalBorderVertices,
                                               position: leftBorderPos,
                                               affectedByGravity: false,
                                               isDynamic: false)
        addBody(leftBorder)
    }

    func addRightBorder(xPos: Double, yPos: Double, height: Double) {
        let verticalBorderVertices = getVerticesForRect(width: borderBuffer * 2, height: height + borderBuffer * 2)

        let rightBorderPos = SIMD2<Double>(x: xPos + borderBuffer, y: height / 2)
        let rightBorder = MSKPolygonPhysicsBody(vertices: verticalBorderVertices,
                                               position: rightBorderPos,
                                               affectedByGravity: false,
                                               isDynamic: false)
        addBody(rightBorder)
    }

    /// Creates a horizontal border at the top of the physics world.
    /// - Parameters:
    ///   - x: The x-coordinate of the mid-point of the border.
    ///   - y: The y-coordinate of the mid-point of the border.
    ///   - length: The length of the border to create.
    func addTopBorder(xPos: Double, yPos: Double, length: Double) {
        let horizontalBorderVertices = getVerticesForRect(width: length + borderBuffer * 2, height: borderBuffer * 2)
        let topBorderPos = SIMD2<Double>(x: xPos, y: yPos - borderBuffer)
        let topBorder = MSKPolygonPhysicsBody(vertices: horizontalBorderVertices,
                                                 position: topBorderPos,
                                                 affectedByGravity: false,
                                                 isDynamic: false)
        addBody(topBorder)
    }

    /// Adds a new body to the physics world.
    func addBody(_ addedBody: MSKPhysicsBody) {
        bodies.append(addedBody)
    }

    /// Removes a body from the physics world.
    ///  If the specified body doesn't exist, then do nothing.
    func removeBody(_ removedBody: MSKPhysicsBody) {
        bodies.removeAll(where: { body in body === removedBody })
    }

    /// Conducts physics simulations on the physics world within the specified time interval.
    func simulatePhysics(timeInterval: TimeInterval) {
        for _ in 0..<substeps {
            applyGravity()
            handleCollisions(timeInterval: timeInterval / Double(substeps))
            updateObjects(timeInterval: timeInterval / Double(substeps))
        }
    }

    /// Applies gravity to the bodies in the physics world.
    private func applyGravity() {
        for body in bodies {
            body.applyGravity(gravity)
        }
    }

    /// Resolves collisions between two physics bodies.
    private func resolveCollision(bodyA: MSKPhysicsBody, bodyB: MSKPhysicsBody) {
        _ = bodyA.collide(with: bodyB)
        _ = bodyB.collide(with: bodyA)
    }

    /// Checks and resolves collisions between all bodies within the world.
    private func handleCollisions(timeInterval: TimeInterval) {
        for idx1 in 0..<bodies.count {
            let bodyA = bodies[idx1]
            for idx2 in (idx1 + 1)..<bodies.count {
                let bodyB = bodies[idx2]
                resolveCollision(bodyA: bodyA, bodyB: bodyB)
            }
        }
    }

    /// Updates the positions of all objects within the world.
    private func updateObjects(timeInterval: TimeInterval) {
        for body in bodies {
            body.updatePosition(timeInterval: timeInterval)
        }
    }
}
