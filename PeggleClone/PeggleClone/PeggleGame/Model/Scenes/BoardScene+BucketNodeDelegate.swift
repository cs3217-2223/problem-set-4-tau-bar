//
//  BoardScene+BucketNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

extension BoardScene: BucketNodeDelegate {
    func didEnterBucket() {
        gameState.didBallEnterBucket()
        handleResetBall()
    }
}
