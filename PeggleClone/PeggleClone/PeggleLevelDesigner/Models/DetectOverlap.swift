//
//  DetectOverlap.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 16/2/23.
//

import Foundation

class DetectOverlap {
    typealias V = SIMD2<Double>

    // TODO: Modify functions
    static func detectOverlap(objectA: Block, objectB: Peg) -> Bool {
        doPegAndBlockOverlap(peg: objectB, block: objectA)
    }

    static func detectOverlap(blockA: Block,
                                    blockB: Block) -> Bool {
        let verticesA = getBlockAbsoluteVertices(block: blockA)
        let verticesB = getBlockAbsoluteVertices(block: blockB)

        for idx in 0..<verticesA.count {
            let firstVertice = verticesA[idx]
            let secondVertice = verticesA[(idx + 1) % verticesA.count]
            let edge = secondVertice - firstVertice
            let axis = SIMD2<Double>(x: -edge.y, y: edge.x)
            let minMaxA: (min: Double, max: Double) = findMinMaxOf(blockVertices: verticesA, along: axis)
            let minMaxB: (min: Double, max: Double) = findMinMaxOf(blockVertices: verticesB, along: axis)
            // If find any separation between the range of values for each body, means no intersection.
            if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
                return false
            }
        }

        for idx in 0..<verticesB.count {
            let firstVertice = verticesB[idx]
            let secondVertice = verticesB[(idx + 1) % verticesB.count]
            let edge = secondVertice - firstVertice
            let axis = SIMD2<Double>(x: -edge.y, y: edge.x)
            let minMaxA: (min: Double, max: Double) = findMinMaxOf(blockVertices: verticesA, along: axis)
            let minMaxB: (min: Double, max: Double) = findMinMaxOf(blockVertices: verticesB, along: axis)

            // If find any separation between the range of values for each body, means no intersection.
            if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
                return false
            }

        }
        return true
    }

    static func doPegAndBlockOverlap(peg: Peg, block: Block) -> Bool {
        let vertices = getBlockAbsoluteVertices(block: block)
        // Check whether there are any non-intersections for all the possible axes for bodyA
        for idx in 0..<vertices.count {
            let firstVertice = vertices[idx]
            let secondVertice = vertices[(idx + 1) % vertices.count]
            let edge = secondVertice - firstVertice
            let axis = V(x: -edge.y, y: edge.x)
            let minMaxA: (min: Double, max: Double) = findMinMaxOf(blockVertices: vertices, along: axis)
            let minMaxB: (min: Double, max: Double) = findMinMaxOf(peg: peg, along: axis)
            // If find any separation between the range of values for each body, means no intersection.
            if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
                return false
            }
        }

        let pegPos = convert(peg.position)

        let closestVertexIdx = findClosestVertice(in: vertices, to: pegPos)
        guard vertices.indices.contains(closestVertexIdx) else { return false }
        let closestPoint = vertices[closestVertexIdx]
        let axis = closestPoint - pegPos
        let minMaxA: (min: Double, max: Double) = findMinMaxOf(blockVertices: vertices, along: axis)
        let minMaxB: (min: Double, max: Double) = findMinMaxOf(peg: peg, along: axis)
        if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
            return false
        }

        return true
    }

    /// Returns the index of vertice in `vertices` that is closest to `point`.
    static func findClosestVertice(in vertices: [V], to point: V) -> Int {
        var minDistance: Double = .infinity
        var minIdx = -1
        for idx in 0..<vertices.count {
            let dist = getDistance(pointA: vertices[idx], pointB: point)
            if dist < minDistance {
                minDistance = dist
                minIdx = idx
            }
        }

        return minIdx
    }

    /// Returns the distance between two vectors.
    static func getDistance(pointA: V, pointB: V) -> Double {
        getLength(of: pointA - pointB)
    }

    /// Returns the length of the vector.
    static func getLength(of vector: V) -> Double {
        sqrt(vector.x * vector.x + vector.y * vector.y)
    }

    static func findMinMaxOf(peg: Peg, along axis: V) -> (min: Double, max: Double) {
        let pos = convert(peg.position)
        let direction = findUnitVector(of: axis)
        let radiusVector = direction * peg.radius

        let firstPoint = pos + radiusVector
        let secondPoint = pos - radiusVector

        let firstPointPositionOnAxis = dotProduct(vectorA: firstPoint, vectorB: axis)
        let secondPointPostionOnAxis = dotProduct(vectorA: secondPoint, vectorB: axis)

        let min = Double.minimum(firstPointPositionOnAxis, secondPointPostionOnAxis)
        let max = Double.maximum(firstPointPositionOnAxis, secondPointPostionOnAxis)

        return (min: min, max: max)
    }

    /// Projects the given vertices onto the provided axis and finds the maximum and minimum values along the axis.
    static func findMinMaxOf(blockVertices: [V], along axis: V) -> (min: Double, max: Double) {
        var min: Double = .infinity
        var max: Double = -.infinity
        // Iterate vertices to find the min and max values along the axis for all the vertices
        // of a polygon.
        for vertex in blockVertices {
            let projection = dotProduct(vectorA: vertex, vectorB: axis)
            if projection < min {
                min = projection
            }
            if projection > max {
                max = projection
            }
        }
        return (min: min, max: max)
    }

    static func getBlockAbsoluteVertices(block: Block) -> [V] {
        let angleDegrees = block.rotation
        let blockVertices = getBlockRelativeVertices(block: block)
        let rotatedRelativeVertices = rotateVertices(vertices: blockVertices,
                                                     by: angleDegrees)
        let vertices = getAbsoluteVertices(relative: rotatedRelativeVertices,
                                           center: block.position)
        return vertices
    }

    static func getBlockRelativeVertices(block: Block) -> [V] {
        var vertices: [V] = []
        let width = block.width
        let height = block.height
        vertices.append(V(-width / 2, -height / 2))
        vertices.append(V(width / 2, -height / 2))
        vertices.append(V(width / 2, height / 2))
        vertices.append(V(-width / 2, height / 2))
        return vertices
    }

    static func detectOverlap(objectA: Peg, objectB: Peg) -> Bool {
        let distanceBetween = calculateEuclideanDistance(positionA: objectA.position, positionB: objectB.position)
        return distanceBetween < (objectA.radius + objectB.radius)
    }

    static func getAbsoluteVertices(relative: [V], center: CGPoint) -> [V] {
        var vertices: [V] = []
        let centerPos = V(center.x, center.y)
        for vertex in relative {
            vertices.append(vertex + centerPos)
        }
        return vertices
    }

    static func convert(_ cgPoint: CGPoint) -> V {
        V(cgPoint.x, cgPoint.y)
    }

    static func convert(_ vector: V) -> CGPoint {
        CGPoint(x: vector.x, y: vector.y)
    }

    static func dotProduct(vectorA: V, vectorB: V) -> Double {
        vectorA.x * vectorB.x + vectorA.y * vectorB.y
    }

    static func rotateVertices(vertices: [V], by angle: Double) -> [V] {
        var rotatedVertices: [V] = []
        for vertex in vertices {
            let newX = vertex.x * cos(angle) - vertex.y * sin(angle)
            let newY = vertex.x * sin(angle) + vertex.y * cos(angle)
            let newVertex = V(newX, newY)
            rotatedVertices.append(newVertex)
        }

        return rotatedVertices
    }

    /// Returns the unit vector of the specified `vector`.
    static func findUnitVector(of vector: V) -> V {
        let length = getLength(of: vector)
        let normalizedVector = vector / length
        return normalizedVector
    }
}
