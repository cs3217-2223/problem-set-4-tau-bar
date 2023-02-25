//
//  BucketNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

protocol BucketNodeDelegate: AnyObject {
    func didEnterBucket(ball: BallPhysicsBody)
}
