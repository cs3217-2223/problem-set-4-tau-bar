//
//  MSKCirclePhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 3/2/23.
//

import Foundation
import CoreGraphics

class MSKCirclePhysicsBody: MSKPhysicsBody {
    /// The radius of the body.
    var radius: Double
    // MARK: Designated & Convenience Initializers
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
        super.init(node: node,
                   position: position,
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
    convenience init(circleOfRadius radius: CGFloat, center: SIMD2<Double>) {
        self.init(radius: radius, position: center)
    }
    override func collide(with body: MSKPhysicsBody) {
        body.collide(with: self)
    }
    override func collide(with body: MSKCirclePhysicsBody) {
        let minDistance = self.radius + body.radius
        let collisionAxis = self.position - body.position
        let collisionAxisLength = getLength(of: collisionAxis)
        // Checks whether the objects are overlapping.
        if collisionAxisLength < minDistance {
            var unitVector = collisionAxis / collisionAxisLength
            let massRatioA = self.mass / (self.mass + body.mass)
            let massRatioB = body.mass / (self.mass + body.mass)
            let delta = 0.5 * defaultResponseCoeff * (collisionAxisLength - minDistance)
            // Update positions of both bodies.
            if isVertical(unitVector) {
                unitVector.x = Double.random(in: -0.5...0.5)
            }
            self.updatePosition(by: -1 * unitVector * (massRatioB * delta))
            body.updatePosition(by: unitVector * (massRatioA * delta))
        }
    }
    override func collide(with body: MSKPolygonPhysicsBody) {
        guard let collisionVector = findCollisionVector(polygon: body, circle: self) else { return }
        body.updatePosition(by: collisionVector.normal * collisionVector.minDepth / 2)
        self.updatePosition(by: -collisionVector.normal * collisionVector.minDepth / 2)
    }
    override func getHeight() -> Double {
        radius * 2
    }
    override func getWidth() -> Double {
        radius * 2
    }
}
