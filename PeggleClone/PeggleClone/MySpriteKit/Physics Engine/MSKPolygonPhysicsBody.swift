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
    /// Vertices of the polygon, relative to the `position` of the polygon.
    /// The vertices are in order (either clockwise or anticlockwise).
    var vertices: [SIMD2<Double>]

    // MARK: Designated & Convenience Initializers
    init(vertices: [SIMD2<Double>],
         position: SIMD2<Double>,
         oldPosition: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass) {
        self.vertices = vertices
        super.init(position: position,
                   oldPosition: oldPosition,
                   acceleration: acceleration,
                   affectedByGravity: affectedByGravity,
                   isDynamic: isDynamic,
                   categoryBitMask: categoryBitMask,
                   mass: mass)
    }

    convenience init(vertices: [SIMD2<Double>],
                     position: SIMD2<Double>,
                     acceleration: SIMD2<Double> = defaultAcceleration,
                     affectedByGravity: Bool = defaultAffectedByGravity,
                     isDynamic: Bool = defaultIsDynamic,
                     categoryBitMask: UInt32 = defaultCategoryBitMask,
                     mass: Double = defaultMass) {
        self.init(vertices: vertices,
                  position: position,
                  oldPosition: position,
                  acceleration: acceleration,
                  affectedByGravity: affectedByGravity,
                  isDynamic: isDynamic,
                  categoryBitMask: categoryBitMask,
                  mass: mass)
    }

    convenience init(polygon vertices: [SIMD2<Double>], center: SIMD2<Double>) {
        self.init(vertices: vertices, position: center)
    }

    // MARK: Methods
    /// Handles collisions with an unspecified type physics body.
    override func collide(with body: MSKPhysicsBody) {
        body.collide(with: self)
    }

    /// Handles collisions with an circle type physics body.
    override func collide(with body: MSKCirclePhysicsBody) {
        guard let collisionVector = findCollisionVector(polygon: self, circle: body) else { return }

        self.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
        body.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
    }

    /// Handles collisions with an polygonal type physics body.
    override func collide(with body: MSKPolygonPhysicsBody) {
        guard let collisionVector = findCollisionVector(polygonA: self, polygonB: body) else { return }

        self.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
        body.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
    }

    /// Returns the width of the polygon.
    override func getWidth() -> Double {
        var minA = maxDoubleValue
        var maxA = minDoubleValue
        for vertex in vertices {
            minA = Double.minimum(minA, vertex.x)
            maxA = Double.maximum(maxA, vertex.x)
        }

        return maxA - minA
    }

    /// Returns the height of the polygon.
    override func getHeight() -> Double {
        var minA = maxDoubleValue
        var maxA = minDoubleValue
        for vertex in vertices {
            minA = Double.minimum(minA, vertex.y)
            maxA = Double.maximum(maxA, vertex.y)
        }

        return maxA - minA
    }
}
