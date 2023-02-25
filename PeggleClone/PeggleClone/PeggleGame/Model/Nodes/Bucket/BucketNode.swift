//
//  BucketNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import UIKit

class BucketNode: MSKSpriteNode {
    weak var bucketDelegate: BucketNodeDelegate?

    init(center: SIMD2<Double>) {
        let bucketPhysicsBody = BucketPhysicsBody(position: center)

        super.init(physicsBody: bucketPhysicsBody,
                   image: UIImage(named: "bucket"))

        bucketPhysicsBody.bucketBase.bucketBaseDelegate = self
    }

}
