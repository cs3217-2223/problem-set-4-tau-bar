//
//  GameViewController+BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import Foundation

extension GameViewController: BoardSceneDelegate {
    func didCollideWithBall(updatedPegNode: PegNode) {
        musicPlayer?.playPopSound()
    }

    func didRemovePegNode(removedNode: PegNode) {
        musicPlayer?.playDeathSound()
    }

    func didAddExplosion(at location: CGPoint, duration: TimeInterval, radius: Double) {
        musicPlayer?.playExplosionSound()
    }

    func didFireCannon() {
        musicPlayer?.playCannonSound()
    }
}
