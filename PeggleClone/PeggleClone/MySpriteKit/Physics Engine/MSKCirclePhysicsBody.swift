//
//  MSKCirclePhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 3/2/23.
//

import Foundation
import CoreGraphics

/// Represents a circular physics body, characterized by `radius`.
class MSKCirclePhysicsBody: MSKPhysicsBody {

    /// The radius of the body.
    var radius: Double

    // MARK: Initializers
    init(node: MSKNode? = nil,
         radius: Double = defaultRadius,
         position: SIMD2<Double>,
         oldPosition: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass) {
        self.radius = radius
        super.init(position: position,
                   oldPosition: oldPosition,
                   acceleration: acceleration,
                   affectedByGravity: affectedByGravity,
                   isDynamic: isDynamic,
                   categoryBitMask: categoryBitMask,
                   mass: mass)
    }

    convenience init(node: MSKNode? = nil,
                     radius: Double = defaultRadius,
                     position: SIMD2<Double>,
                     acceleration: SIMD2<Double> = defaultAcceleration,
                     affectedByGravity: Bool = defaultAffectedByGravity,
                     isDynamic: Bool = defaultIsDynamic,
                     categoryBitMask: UInt32 = defaultCategoryBitMask,
                     mass: Double = defaultMass) {
        self.init(node: node,
                  radius: radius,
                  position: position,
                  oldPosition: position,
                  acceleration: acceleration,
                  affectedByGravity: affectedByGravity,
                  isDynamic: isDynamic,
                  categoryBitMask: categoryBitMask,
                  mass: mass)
    }

    convenience init(circleOfRadius radius: CGFloat, center: SIMD2<Double>, isDynamic: Bool) {
        self.init(radius: radius, position: center, isDynamic: isDynamic)
    }

    convenience init(circleOfRadius radius: CGFloat, oldPosition: SIMD2<Double>, position: SIMD2<Double>, isDynamic: Bool) {
        self.init(radius: radius, position: position, oldPosition: oldPosition, isDynamic: isDynamic)
    }

    /// Handles collision of the circle body with another unspecified type physics body.
    override func collide(with body: MSKPhysicsBody) -> Bool {
        body.collide(with: self)
    }

    /// Handles collision of the circle body with another circle physics body.
    override func collide(with body: MSKCirclePhysicsBody) -> Bool {
        let minDistance = self.radius + body.radius
        let collisionAxis = self.position - body.position
        let collisionAxisLength = getLength(of: collisionAxis)

        // Checks whether the objects are overlapping.
        if collisionAxisLength < minDistance {
            var unitVector = collisionAxis / collisionAxisLength
            let massRatioA = self.mass / (self.mass + body.mass)
            let massRatioB = body.mass / (self.mass + body.mass)
            let delta = 0.5 * defaultResponseCoeff * (collisionAxisLength - minDistance)

            // Add random horizontal acceleration if the circles are directly
            // on top of each other.
            if isVertical(unitVector) {
                unitVector.x = Double.random(in: -0.5...0.5)
            }

            // Update positions of both bodies.
            self.updatePosition(by: -1 * unitVector * (massRatioB * delta))
            body.updatePosition(by: unitVector * (massRatioA * delta))
            return true
        }

        return false
    }

    /// Handles collision of the circle body with a polygonal physics body.
    override func collide(with body: MSKPolygonPhysicsBody) -> Bool {
        guard let collisionVector = findCollisionVector(polygon: body, circle: self) else { return false }
        body.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
        self.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
        return true
    }

    /// Returns height of the body.
    override func getHeight() -> Double {
        radius * 2
    }

    /// Returns width of the body.
    override func getWidth() -> Double {
        radius * 2
    }
}
