//
//  UtilityFunctions.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 15/2/23.
//

import Foundation

/// Calculates the 2D Euclidian distance .
func calculateEuclideanDistance(positionA: CGPoint, positionB: CGPoint) -> Double {
    let distance = sqrt(pow(positionA.x - positionB.x, 2)
                        + pow(positionA.y - positionB.y, 2))
    return distance
}
