//
//  DetectOverlap.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 16/2/23.
//

import Foundation

class DetectOverlap {
    // TODO: Modify functions
    static func detectOverlap(objectA: Block, objectB: Peg) -> Bool {
        // Calculate the vector from the center of the block to the center of the peg
        let centerToCenter = CGPoint(x: objectB.position.x - objectA.position.x, y: objectB.position.y - objectA.position.y)

        // Calculate the closest point on the block to the center of the peg
        let closestPoint = closestPointOnBlock(block: objectA, point: objectB.position)

        // Calculate the vector from the closest point to the center of the peg
        let closestToCenter = CGPoint(x: objectB.position.x - closestPoint.x, y: objectB.position.y - closestPoint.y)

        // Check if the distance between the closest point and the center of the peg is less than the peg's radius
        return hypot(closestToCenter.x, closestToCenter.y) < objectB.radius
    }

    static func closestPointOnBlock(block: Block, point: CGPoint) -> CGPoint {
        // Calculate the position of the point relative to the block's center
        let position = CGPoint(x: point.x - block.position.x, y: point.y - block.position.y)

        // Calculate the angle between the x-axis and the block's edges
        let angle = atan2(block.height, block.width)

        // Calculate the length of the vector from the block's center to the closest point on the block
        let length = min(abs(position.x / cos(angle)), abs(position.y / sin(angle)))

        // Calculate the position of the closest point on the block relative to the block's center
        let closestPosition = CGPoint(x: length * cos(angle), y: length * sin(angle))

        // Convert the position back to global coordinates
        return CGPoint(x: block.position.x + closestPosition.x, y: block.position.y + closestPosition.y)
    }
}
