//
//  Constants.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import Foundation

// MARK: Constants for `MSKPhysicsBody`
let defaultRadius: Double = 20.0
let defaultAcceleration: SIMD2<Double> = .zero
let defaultAffectedByGravity = true
let defaultIsDynamic = true
let defaultCategoryBitMask: UInt32 = 0xFFFFFFFF
let defaultVelocity: CGVector = .zero
let defaultAngularVelocity: CGFloat = .zero
let defaultMass: Double = 1.0

// MARK: Constants for `MSKPhysicsWorld`
let defaultGravity: SIMD2<Double> = SIMD2(x: 0, y: 200)
let defaultResponseCoeff: Double = 0.75
