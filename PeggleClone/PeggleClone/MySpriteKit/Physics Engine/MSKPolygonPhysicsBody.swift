//
//  MSKPolygonPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 3/2/23.
//

import Foundation
import CoreGraphics

/// Represents a polygonal physics body, characterized by `vertices`.
class MSKPolygonPhysicsBody: MSKPhysicsBody {
    var angle: Double

    weak var delegate: MSKPhysicsBodyDelegate?

    var positionLast: SIMD2<Double>

    var position: SIMD2<Double>

    var acceleration: SIMD2<Double>

    var affectedByGravity: Bool

    var isDynamic: Bool

    var categoryBitMask: UInt32

    var mass: Double

    /// Vertices of the polygon, relative to the `position` of the polygon.
    /// The vertices are in order (either clockwise or anticlockwise).
    var vertices: [SIMD2<Double>]

    // MARK: Designated & Convenience Initializers
    internal init(delegate: MSKPhysicsBodyDelegate? = nil,
                  positionLast: SIMD2<Double>,
                  position: SIMD2<Double>,
                  acceleration: SIMD2<Double> = defaultAcceleration,
                  affectedByGravity: Bool = defaultAffectedByGravity,
                  isDynamic: Bool = defaultIsDynamic,
                  categoryBitMask: UInt32 = defaultCategoryBitMask,
                  mass: Double = defaultMass,
                  vertices: [SIMD2<Double>],
                  angle: Double = defaultAngle
    ) {
        self.delegate = delegate
        self.positionLast = positionLast
        self.position = position
        self.acceleration = acceleration
        self.affectedByGravity = affectedByGravity
        self.isDynamic = isDynamic
        self.categoryBitMask = categoryBitMask
        self.mass = mass
        self.vertices = vertices
        self.angle = angle
    }

    convenience init(vertices: [SIMD2<Double>],
                     position: SIMD2<Double>,
                     acceleration: SIMD2<Double> = defaultAcceleration,
                     affectedByGravity: Bool = defaultAffectedByGravity,
                     isDynamic: Bool = defaultIsDynamic,
                     categoryBitMask: UInt32 = defaultCategoryBitMask,
                     mass: Double = defaultMass,
                     rotation: Double = 0) {
        self.init(positionLast: position,
                  position: position,
                  acceleration: acceleration,
                  affectedByGravity: affectedByGravity,
                  isDynamic: isDynamic,
                  categoryBitMask: categoryBitMask,
                  mass: mass,
                  vertices: vertices,
                  angle: rotation
        )
    }

    convenience init(polygon vertices: [SIMD2<Double>], center: SIMD2<Double>, rotation: Double) {
        self.init(vertices: vertices, position: center, rotation: rotation)
    }

    // MARK: Methods
    /// Handles collisions with an unspecified type physics body.
    func collide(with body: MSKPhysicsBody) -> Bool {
        if !isCollidable(with: body) {
            return false
        }

        return body.collide(with: self)
    }

    /// Handles collisions with an circle type physics body.
    func collide(with body: MSKCirclePhysicsBody) -> Bool {
        if !isCollidable(with: body) {
            return false
        }

        guard let collisionVector = PhysicsUtil.findCollisionVector(polygon: self, circle: body) else { return false }

        self.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
        body.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
        return true
    }

    /// Handles collisions with an polygonal type physics body.
    func collide(with body: MSKPolygonPhysicsBody) -> Bool {
        if !isCollidable(with: body) {
            return false
        }

        guard let collisionVector = PhysicsUtil.findCollisionVector(polygonA: self, polygonB: body) else {
            return false
        }

        self.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
        body.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
        return true
    }

    /// Returns the width of the polygon.
    func getWidth() -> Double {
        var minA = PhysicsUtil.maxDoubleValue
        var maxA = PhysicsUtil.minDoubleValue
        for vertex in vertices {
            minA = Double.minimum(minA, vertex.x)
            maxA = Double.maximum(maxA, vertex.x)
        }

        return maxA - minA
    }

    /// Returns the height of the polygon.
    func getHeight() -> Double {
        var minA = PhysicsUtil.maxDoubleValue
        var maxA = PhysicsUtil.minDoubleValue
        for vertex in vertices {
            minA = Double.minimum(minA, vertex.y)
            maxA = Double.maximum(maxA, vertex.y)
        }

        return maxA - minA
    }
}
