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
    var angle: Double

    var delegate: MSKPhysicsBodyDelegate?

    var positionLast: SIMD2<Double>

    var position: SIMD2<Double>

    var acceleration: SIMD2<Double>

    var affectedByGravity: Bool

    var isDynamic: Bool

    var categoryBitMask: UInt32

    var mass: Double

    /// The radius of the body.
    var radius: Double

    // MARK: Initializers
    init(delegate: MSKPhysicsBodyDelegate? = nil,
         positionLast: SIMD2<Double>,
         position: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass,
         radius: Double = defaultRadius,
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
        self.radius = radius
        self.angle = angle
    }

    convenience init(delegate: MSKPhysicsBodyDelegate? = nil,
                     position: SIMD2<Double>,
                     acceleration: SIMD2<Double> = defaultAcceleration,
                     affectedByGravity: Bool = defaultAffectedByGravity,
                     isDynamic: Bool = defaultIsDynamic,
                     categoryBitMask: UInt32 = defaultCategoryBitMask,
                     mass: Double = defaultMass,
                     radius: Double = defaultRadius) {
        self.init(delegate: delegate,
                  positionLast: position,
                  position: position,
                  acceleration: acceleration,
                  affectedByGravity: affectedByGravity,
                  isDynamic: isDynamic,
                  categoryBitMask: categoryBitMask,
                  mass: mass,
                  radius: radius)
    }

    convenience init(circleOfRadius radius: CGFloat,
                     oldPosition: SIMD2<Double>,
                     position: SIMD2<Double>,
                     isDynamic: Bool) {
        self.init(positionLast: oldPosition,
                  position: position,
                  isDynamic: isDynamic,
                  radius: radius)
    }

    convenience init(circleOfRadius radius: CGFloat, center: SIMD2<Double>, isDynamic: Bool) {
        self.init(position: center, isDynamic: isDynamic, radius: radius)
    }

    /// Handles collision of the circle body with another unspecified type physics body.
    func collide(with body: MSKPhysicsBody) -> Bool {
        body.collide(with: self)
    }

    /// Handles collision of the circle body with another circle physics body.
    func collide(with body: MSKCirclePhysicsBody) -> Bool {
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
    func collide(with body: MSKPolygonPhysicsBody) -> Bool {
        guard let collisionVector = findCollisionVector(polygon: body, circle: self) else { return false }
        body.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
        self.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
        return true
    }

    /// Returns height of the body.
    func getHeight() -> Double {
        radius * 2
    }

    /// Returns width of the body.
    func getWidth() -> Double {
        radius * 2
    }
}
