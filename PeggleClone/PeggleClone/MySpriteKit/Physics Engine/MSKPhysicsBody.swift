//
//  MyPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 31/1/23.
//

import Foundation
import CoreGraphics

/// Represents a physical body in the Physics World.
class MSKPhysicsBody {
    weak var delegate: MSKPhysicsBodyDelegate?

    /// The previous position of the center of the body.
    var positionLast: SIMD2<Double>

    /// The current position of the center of the body.
    var position: SIMD2<Double>

    /// The current acceleration of the body.
    var acceleration: SIMD2<Double>

    /// A Boolean value indicating whether the physics body is affected by gravity.
    var affectedByGravity: Bool

    /// A Boolean value indivating whether the physics body is moved by the physics simulation.
    var isDynamic: Bool

    /// A mask that defines which categories this physics body belongs to.
    var categoryBitMask: UInt32

    /// The mass of the physics body (in kgs).
    var mass: Double

    // MARK: Designated & Convenience Initializers
    init(position: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass) {
        self.position = position
        self.positionLast = position
        self.acceleration = acceleration
        self.affectedByGravity = affectedByGravity
        self.isDynamic = isDynamic
        self.categoryBitMask = categoryBitMask
        self.mass = mass
    }

    init(position: SIMD2<Double>,
         oldPosition: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass) {
        self.position = position
        self.positionLast = oldPosition
        self.acceleration = acceleration
        self.affectedByGravity = affectedByGravity
        self.isDynamic = isDynamic
        self.categoryBitMask = categoryBitMask
        self.mass = mass
    }

    // MARK: Methods
    /// Updates the positon of the body given the specified `timeInterval` to calculate
    /// the new position of the body using Verlet integration.
    func updatePosition(timeInterval: TimeInterval) {
        if !isDynamic {
            return
        }

        let displacement = position - positionLast
        positionLast = position
        position = position + displacement + acceleration * (timeInterval * timeInterval)
        acceleration = .zero

        delegate?.didUpdatePosition()
    }

    /// Applies gravirty to the physics body.
    /// If the body' s `affectedByGravity` is set to false, then do nothing.
    func applyGravity(_ gravity: SIMD2<Double>) {
        if !affectedByGravity {
            return
        }
        accelerate(acc: gravity)
    }

    /// Updates the position of body by the specified vector.
    /// The specified `vector` is added to the current position.
    func updatePosition(by vector: SIMD2<Double>) {
        if !isDynamic {
            return
        }
        position += vector
    }

    /// Increases the acceleration of the physics body by the specified amount.
    func accelerate(acc: SIMD2<Double>) {
        acceleration += acc
    }

    /// Sets the velocity of the body.
    func setVelocity(newVelocity: SIMD2<Double>, timeInterval: TimeInterval) {
        positionLast = position - (newVelocity * timeInterval)
    }

    /// Adds velocity to the body.
    func addVelocity(velocity: SIMD2<Double>, timeInterval: TimeInterval) {
        positionLast -= velocity * timeInterval
    }

    /// Returns the current velocity of the body.
    func getVelocity(timeInterval: TimeInterval) -> SIMD2<Double> {
        (position - positionLast) / timeInterval
    }

    // MARK: Abstract methods - these methods must be overridden by the subclass.
    func collide(with body: MSKPhysicsBody) {
        assert(false, "This method must be overridden by subclass.")
    }
    func collide(with body: MSKCirclePhysicsBody) {
        assert(false, "This method must be overridden by subclass.")
    }
    func collide(with body: MSKPolygonPhysicsBody) {
        assert(false, "This method must be overridden by subclass.")
    }
    func getHeight() -> Double {
        assert(false, "This method must be overridden by subclass.")
        return 0.0
    }
    func getWidth() -> Double {
        assert(false, "This method must be overridden by subclass.")
        return 0.0
    }
}
