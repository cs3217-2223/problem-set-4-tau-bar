//
//  GameViewController+BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import Foundation

extension GameViewController: BoardSceneDelegate {
    func didEnterBucket(gameState: GameState, at location: CGPoint) {
        musicPlayer?.playEnterBucket()
    }

    func didHitBallFirstTime(pegNode: PegNode) {
        // insert any code to run when ball hits peg for first time
    }

    func didCollideWithBall(updatedPegNode: PegNode) {
        musicPlayer?.playPopSound()
    }

    func didRemoveBoardNode(removedNode: BoardObjectNode) {
        if removedNode is PegNode {
            musicPlayer?.playDeathSound()
        }
    }

    func didAddExplosion(at location: CGPoint, duration: TimeInterval, radius: Double) {
        musicPlayer?.playExplosionSound()
    }

    func didFireCannon() {
        musicPlayer?.playCannonSound()
    }
}
