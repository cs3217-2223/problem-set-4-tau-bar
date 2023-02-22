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
        doPegAndBlockOverlap(peg: objectB, block: objectA)
    }

    static func doPegAndBlockOverlap(peg: Peg, block: Block) -> Bool {
        let circleDistance = (x: abs(peg.position.x - block.position.x), y: abs(peg.position.y - block.position.y))

        if circleDistance.x > (block.width / 2 + peg.radius) { return false }
        if circleDistance.y > (block.height / 2 + peg.radius) { return false }

        if circleDistance.x <= (block.width / 2) { return true }
        if circleDistance.y <= (block.height / 2) { return true }

        let cornerDistanceSq = pow(circleDistance.x - block.width / 2, 2) +
                                 pow(circleDistance.y - block.height / 2, 2)

        return (cornerDistanceSq <= pow(peg.radius, 2))
    }

    static func detectOverlap(objectA: Peg, objectB: Peg) -> Bool {
        let distanceBetween = calculateEuclideanDistance(positionA: objectA.position, positionB: objectB.position)
        return distanceBetween < (objectA.radius + objectB.radius)
    }

    static func detectOverlap(objectA: Block, objectB: Block) -> Bool {
        let aRight = objectA.position.x + objectA.width
        let aTop = objectA.position.y + objectA.height
        let bRight = objectB.position.x + objectB.width
        let bTop = objectB.position.y + objectB.height

        if objectA.position.x >= bRight || objectB.position.x >= aRight {
            return false // rectangles do not overlap on X-axis
        }

        if objectA.position.y >= bTop || objectB.position.y >= aTop {
            return false // rectangles do not overlap on Y-axis
        }

        return true // rectangles overlap on both X and Y axes
    }

    static func getAbsoluteVertices(of block: Block) -> [CGPoint] {
        var vertices: [CGPoint] = []
        vertices.append(CGPoint(x: block.position.x - block.width / 2, y: block.position.x - block.height / 2))
        vertices.append(CGPoint(x: block.position.x - block.width / 2, y: block.position.x + block.height / 2))
        vertices.append(CGPoint(x: block.position.x + block.width / 2, y: block.position.x + block.height / 2))
        vertices.append(CGPoint(x: block.position.x + block.width / 2, y: block.position.x - block.height / 2))
        return vertices
    }

    static func dotProduct(vectorA: SIMD2<Double>, vectorB: SIMD2<Double>) -> Double {
        vectorA.x * vectorB.x + vectorA.y * vectorB.y
    }
}
