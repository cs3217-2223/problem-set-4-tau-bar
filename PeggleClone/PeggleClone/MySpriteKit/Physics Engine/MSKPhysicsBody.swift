//
//  MyPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 31/1/23.
//

import Foundation
import CoreGraphics

class MSKPhysicsBody {
    ///
    weak var node: MSKNode?
    /// The radius of the body.
    var radius: Double
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
    var mass: Double
    
    // MARK: Designated & Convenience Initializers
    init(node: MSKNode? = nil,
         radius: Double = defaultRadius,
         position: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass) {
        self.node = node
        self.radius = radius
        self.position = position
        self.positionLast = position
        self.acceleration = acceleration
        self.affectedByGravity = affectedByGravity
        self.isDynamic = isDynamic
        self.categoryBitMask = categoryBitMask
        self.mass = mass
    }
    init(node: MSKNode? = nil,
         radius: Double = defaultRadius,
         position: SIMD2<Double>,
         oldPosition: SIMD2<Double>,
         acceleration: SIMD2<Double> = defaultAcceleration,
         affectedByGravity: Bool = defaultAffectedByGravity,
         isDynamic: Bool = defaultIsDynamic,
         categoryBitMask: UInt32 = defaultCategoryBitMask,
         mass: Double = defaultMass) {
        self.node = node
        self.radius = radius
        self.position = position
        self.positionLast = oldPosition
        self.acceleration = acceleration
        self.affectedByGravity = affectedByGravity
        self.isDynamic = isDynamic
        self.categoryBitMask = categoryBitMask
        self.mass = mass
    }
    convenience init(circleOfRadius radius: CGFloat, center: SIMD2<Double>) {
        self.init(radius: radius, position: center)
    }
    func updatePosition(dt: TimeInterval) {
        if !isDynamic {
            return
        }
        
        let displacement = position - positionLast
        positionLast = position
        position = position + displacement + acceleration * (dt * dt)
        acceleration = .zero
    }
    func applyGravity(_ gravity: SIMD2<Double>) {
        if !affectedByGravity {
            return
        }
        
        accelerate(acc: gravity)
    }
    func updatePosition(by vector: SIMD2<Double>) {
        if !isDynamic {
            return
        }
        
        position += vector
    }
    func accelerate(acc: SIMD2<Double>) {
        acceleration += acc
    }
    func setVelocity(newVelocity: SIMD2<Double>, dt: TimeInterval) {
        positionLast = position - (newVelocity * dt)
    }
    func addVelocity(velocity: SIMD2<Double>, dt: TimeInterval) {
        positionLast -= velocity * dt
    }
    func getVelocity(dt: TimeInterval) -> SIMD2<Double> {
        (position - positionLast)/dt
    }
}
