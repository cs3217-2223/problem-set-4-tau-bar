//
//  BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import Foundation

protocol BoardSceneDelegate: AnyObject {
    func didCollideWithBall(updatedPegNode: PegNode)

    func didHitBallFirstTime(pegNode: PegNode)

    func didRemovePegNode(removedNode: PegNode)

    func didAddExplosion(at location: CGPoint, duration: TimeInterval, radius: Double)

    func didFireCannon()
    
    func didEnterBucket(gameState: GameState, at location: CGPoint)
}
