//
//  MyPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 31/1/23.
//

import Foundation
import CoreGraphics

/// Represents a physical body in the Physics World.
protocol MSKPhysicsBody: AnyObject {
    var delegate: MSKPhysicsBodyDelegate? { get set }

    /// The previous position of the center of the body.
    var positionLast: SIMD2<Double> { get set }

    /// The current position of the center of the body.
    var position: SIMD2<Double> { get set }

    /// The current acceleration of the body.
    var acceleration: SIMD2<Double> { get set }

    /// A Boolean value indicating whether the physics body is affected by gravity.
    var affectedByGravity: Bool { get set }

    /// A Boolean value indicating whether the physics body is moved by the physics simulation.
    var isDynamic: Bool { get set }

    /// A mask that defines which categories this physics body belongs to.
    var categoryBitMask: UInt32 { get set }

    /// The mass of the physics body (in kgs).
    var mass: Double { get set }

    /// Angle of rotation (anticlockwise)
    var angle: Double { get set }

    /// Updates the position of the physics body after a `timeInterval`.
    func updatePosition(timeInterval: TimeInterval)

    /// Applies gravity to the physics body.
    func applyGravity(_ gravity: SIMD2<Double>)

    /// Updates the position by the specified vector.
    func updatePosition(by vector: SIMD2<Double>)

    /// Accelerates the physics body.
    func accelerate(acc: SIMD2<Double>)

    /// Sets the velocity to the `newVelocity` after a `timeInterval`.
    func setVelocity(newVelocity: SIMD2<Double>, timeInterval: TimeInterval)

    /// Adds velocity after a `timeInterval`.
    func addVelocity(velocity: SIMD2<Double>, timeInterval: TimeInterval)

    /// Returns the current velocity given the `timeInterval`.
    func getVelocity(timeInterval: TimeInterval) -> SIMD2<Double>

    /// Simulates collision with an unspecified type of physics body.
    func collide(with body: MSKPhysicsBody) -> Bool

    /// Simulates collision with a circle type of physics body.
    func collide(with body: MSKCirclePhysicsBody) -> Bool

    /// Simulates collision with a polygon type of physics body.
    func collide(with body: MSKPolygonPhysicsBody) -> Bool

    /// Returns the height of the body.
    func getHeight() -> Double

    /// Returns the width of the body.
    func getWidth() -> Double

    /// Checks whether the physics body will collide with another physics body based on `categoryBitMask`.
    func isCollidable(with body: MSKPhysicsBody) -> Bool
}

extension MSKPhysicsBody {
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

    /// Checks whether the physics body will collide with another physics body based on `categoryBitMask`.
    func isCollidable(with body: MSKPhysicsBody) -> Bool {
        categoryBitMask & body.categoryBitMask != 0
    }
}
