//
//  UtilFunctions.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 3/2/23.
//
import Foundation

let maxDoubleValue = Double.greatestFiniteMagnitude
let minDoubleValue = -Double.greatestFiniteMagnitude

func isVertical(_ unitVector: SIMD2<Double>) -> Bool {
    unitVector.y == 1.0 || unitVector.y == -1.0
}

func getLength(of vector: SIMD2<Double>) -> Double {
    sqrt(vector.x * vector.x + vector.y * vector.y)
}

func getDistance(pointA: SIMD2<Double>, pointB: SIMD2<Double>) -> Double {
    getLength(of: pointA - pointB)
}

/// Checks whether the polygons are intersecting using Separation Axis Theorem,
/// and finds the smallest depth along the intersecting axis.
/// Returns the unit vector of the axis of collision and the minimum depth.
///
/// Example usage:
/// ```
/// let collision = findCollisionVector(polygonA, polygonB)
/// // polygonA will now move in the direction of -normal after the collision
/// // polygonB will move in direction of normal after the collision
/// ```
func findCollisionVector(polygonA: MSKPolygonPhysicsBody,
                         polygonB: MSKPolygonPhysicsBody) -> (minDepth: Double, normal: SIMD2<Double>)? {
    // TODO: Abstract out functions
    let verticesA = getAbsoluteVertices(of: polygonA)
    let verticesB = getAbsoluteVertices(of: polygonB)
    var minDepth = maxDoubleValue
    var normal = SIMD2<Double>.zero
    // Check whether there are any non-intersections for all the possible axes for bodyA
    for idx in 0..<polygonA.vertices.count {
        let firstVertice = verticesA[idx]
        let secondVertice = verticesA[(idx + 1) % verticesA.count]
        let edge = secondVertice - firstVertice
        let axis = SIMD2<Double>(x: -edge.y, y: edge.x)
        let minMaxA: (min: Double, max: Double) = findMinMaxOf(vertices: verticesA, along: axis)
        let minMaxB: (min: Double, max: Double) = findMinMaxOf(vertices: verticesB, along: axis)
        // If find any separation between the range of values for each body, means no intersection.
        if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
            return nil
        }
        let axisDepth = Double.minimum(minMaxA.max - minMaxB.min, minMaxB.max - minMaxA.min)
        if axisDepth < minDepth {
            minDepth = axisDepth
            normal = axis
        }
    }
    // Check whether there are any non-intersections for all possible axes for bodyB
    for idx in 0..<polygonB.vertices.count {
        let firstVertice = verticesB[idx]
        let secondVertice = verticesB[(idx + 1) % verticesB.count]
        let edge = secondVertice - firstVertice
        let axis = SIMD2<Double>(x: -edge.y, y: edge.x)
        let minMaxA: (min: Double, max: Double) = findMinMaxOf(vertices: verticesA, along: axis)
        let minMaxB: (min: Double, max: Double) = findMinMaxOf(vertices: verticesB, along: axis)
        // If find any separation between the range of values for each body, means no intersection.
        if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
            return nil
        }
        let axisDepth = Double.minimum(minMaxA.max - minMaxB.min, minMaxB.max - minMaxA.min)
        if axisDepth < minDepth {
            minDepth = axisDepth
            normal = axis
        }
    }
    minDepth /= getLength(of: normal)
    normal = findUnitVector(of: normal)
    let centerA = findPolygonCenter(absoluteVertices: verticesA)
    let centerB = findPolygonCenter(absoluteVertices: verticesB)
    let direction = centerB - centerA
    // Reverse the normal direction such that the collision indicates direction for bodyB
    if dotProduct(vectorA: direction, vectorB: normal) < 0 {
        normal = -normal
    }
    return (minDepth: minDepth, normal: normal)
}

func findCollisionVector(polygon: MSKPolygonPhysicsBody,
                         circle: MSKCirclePhysicsBody) -> (minDepth: Double, normal: SIMD2<Double>)? {
    let vertices = getAbsoluteVertices(of: polygon)
    var minDepth = maxDoubleValue
    var normal = SIMD2<Double>.zero
    // Check whether there are any non-intersections for all the possible axes for bodyA
    for idx in 0..<polygon.vertices.count {
        let firstVertice = vertices[idx]
        let secondVertice = vertices[(idx + 1) % vertices.count]
        let edge = secondVertice - firstVertice
        let axis = SIMD2<Double>(x: -edge.y, y: edge.x)
        let minMaxA: (min: Double, max: Double) = findMinMaxOf(vertices: vertices, along: axis)
        let minMaxB: (min: Double, max: Double) = findMinMaxOf(circle: circle, along: axis)
        // If find any separation between the range of values for each body, means no intersection.
        if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
            return nil
        }
        let axisDepth = Double.minimum(minMaxA.max - minMaxB.min, minMaxB.max - minMaxA.min)
        if axisDepth < minDepth {
            minDepth = axisDepth
            normal = axis
        }
    }

    let closestPoint = vertices[findClosestVertice(in: vertices, to: circle.position)]
    let axis = closestPoint - circle.position
    let minMaxA: (min: Double, max: Double) = findMinMaxOf(vertices: vertices, along: axis)
    let minMaxB: (min: Double, max: Double) = findMinMaxOf(circle: circle, along: axis)
    if minMaxA.min >= minMaxB.max || minMaxB.min >= minMaxA.max {
        return nil
    }
    let axisDepth = Double.minimum(minMaxA.max - minMaxB.min, minMaxB.max - minMaxA.min)
    if axisDepth < minDepth {
        minDepth = axisDepth
        normal = axis
    }

    minDepth /= getLength(of: normal)
    normal = findUnitVector(of: normal)
    let polygonCenter = findPolygonCenter(absoluteVertices: vertices)
    let direction = polygonCenter - circle.position
    // Reverse the normal direction such that the collision indicates direction for bodyB
    if dotProduct(vectorA: direction, vectorB: normal) < 0 {
        normal = -normal
    }
    return (minDepth: minDepth, normal: normal)
}

/// Returns the index of vertice in `vertices` that is closest to `point`.
func findClosestVertice(in vertices: [SIMD2<Double>], to point: SIMD2<Double>) -> Int {
    var minDistance = maxDoubleValue
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

func findPolygonCenter(absoluteVertices: [SIMD2<Double>]) -> SIMD2<Double> {
    var sumX: Double = 0
    var sumY: Double = 0

    for vertex in absoluteVertices {
        sumX += vertex.x
        sumY += vertex.y
    }

    return SIMD2<Double>(x: sumX / Double(absoluteVertices.count), y: sumY / Double(absoluteVertices.count))
}

func findUnitVector(of vector: SIMD2<Double>) -> SIMD2<Double> {
    let length = getLength(of: vector)
    let normalizedVector = vector / length
    return normalizedVector
}

/// Projects the given vertices onto the provided axis and finds the maximum and minimum values along the axis.
func findMinMaxOf(vertices: [SIMD2<Double>], along axis: SIMD2<Double>) -> (min: Double, max: Double) {
    var min = maxDoubleValue
    var max = minDoubleValue
    // Iterate vertices to find the min and max values along the axis for all the vertices
    // of a polygon.
    for vertex in vertices {
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

func findMinMaxOf(circle: MSKCirclePhysicsBody, along axis: SIMD2<Double>) -> (min: Double, max: Double) {
    let direction = findUnitVector(of: axis)
    let radiusVector = direction * circle.radius

    let firstPoint = circle.position + radiusVector
    let secondPoint = circle.position - radiusVector

    let firstPointPositionOnAxis = dotProduct(vectorA: firstPoint, vectorB: axis)
    let secondPointPostionOnAxis = dotProduct(vectorA: secondPoint, vectorB: axis)

    let min = Double.minimum(firstPointPositionOnAxis, secondPointPostionOnAxis)
    let max = Double.maximum(firstPointPositionOnAxis, secondPointPostionOnAxis)

    return (min: min, max: max)
}

func dotProduct(vectorA: SIMD2<Double>, vectorB: SIMD2<Double>) -> Double {
    vectorA.x * vectorB.x + vectorA.y * vectorB.y
}

func getVerticesForRect(width: Double, height: Double) -> [SIMD2<Double>] {
    let halfWidth = width / 2
    let halfHeight = height / 2
    return [SIMD2<Double>(x: -halfWidth, y: -halfHeight),
     SIMD2<Double>(x: halfWidth, y: -halfHeight),
     SIMD2<Double>(x: halfWidth, y: halfHeight),
     SIMD2<Double>(x: -halfWidth, y: halfHeight)
    ]
}

func getAbsoluteVertices(of polygon: MSKPolygonPhysicsBody) -> [SIMD2<Double>] {
    polygon.vertices.map({ vertex in
        vertex + polygon.position
    })
}
