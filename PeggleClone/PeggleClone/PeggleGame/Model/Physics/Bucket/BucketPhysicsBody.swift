//
//  BucketPhysicsBody.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class BucketPhysicsBody: MSKPolygonPhysicsBody {
    let bucketBase: BucketBasePhysicsBody
    let bucketLeft: MSKPolygonPhysicsBody
    let bucketRight: MSKPolygonPhysicsBody

    static let defaultWidth: Double = 200
    static let defaultHeight: Double = 100
    static let defaultLeftVertices: [SIMD2<Double>] = [SIMD2<Double>(-BucketPhysicsBody.defaultWidth / 2, -BucketPhysicsBody.defaultHeight / 2),
                                                       SIMD2<Double>(-BucketPhysicsBody.defaultWidth / 2 + 10, -BucketPhysicsBody.defaultHeight / 2),
                                                       SIMD2<Double>(-0.6 * BucketPhysicsBody.defaultWidth / 2 + 10, BucketPhysicsBody.defaultHeight / 2),
                                                       SIMD2<Double>(-0.6 * BucketPhysicsBody.defaultWidth / 2, BucketPhysicsBody.defaultHeight / 2)]

    static let defaultRightVertices: [SIMD2<Double>] = [SIMD2<Double>(BucketPhysicsBody.defaultWidth / 2, -BucketPhysicsBody.defaultHeight / 2),
                                                       SIMD2<Double>(BucketPhysicsBody.defaultWidth / 2 + 10, -BucketPhysicsBody.defaultHeight / 2),
                                                       SIMD2<Double>(0.6 * BucketPhysicsBody.defaultWidth / 2 + 10, BucketPhysicsBody.defaultHeight / 2),
                                                       SIMD2<Double>(0.6 * BucketPhysicsBody.defaultWidth / 2, BucketPhysicsBody.defaultHeight / 2)]

    init(position: SIMD2<Double>) {
        // Bucket base
        let baseVertices = PhysicsUtil.getVerticesForRect(width: 0.6 * Double(Self.defaultWidth),
                                                      height: 20)
        let basePosition = SIMD2<Double>(position.x,
                                         position.y + BucketPhysicsBody.defaultHeight / 2 - 10)
        self.bucketBase = BucketBasePhysicsBody(vertices: baseVertices, position: basePosition, isDynamic: false)

        // Bucket left & right side
        let leftPos = SIMD2<Double>(position.x - BucketPhysicsBody.defaultWidth / 2 + 10,
                                   position.y)
        let rightPos = SIMD2<Double>(position.x + BucketPhysicsBody.defaultWidth / 2 - 10,
                                     position.y)
        self.bucketLeft = MSKPolygonPhysicsBody(vertices: BucketPhysicsBody.defaultLeftVertices, position: leftPos)
        self.bucketRight = MSKPolygonPhysicsBody(vertices: BucketPhysicsBody.defaultRightVertices, position: rightPos)

        let vertices = PhysicsUtil.getVerticesForRect(width: Double(Self.defaultWidth),
                                                      height: Double(Self.defaultHeight))
        super.init(positionLast: position, position: position, isDynamic: false, vertices: vertices)
        self.categoryBitMask = 0
    }

    /// Moves the entire bucket, including base and sides.
    func move(by displacement: SIMD2<Double>) {
        position += displacement
        bucketBase.position += displacement
        bucketLeft.position += displacement
        bucketRight.position += displacement

        delegate?.didUpdatePosition()
    }
}
