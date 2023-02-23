//
//  BoardScene+PegNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension BoardScene: PegNodeDelegate {
    func didCollideWithBall(pegNode: PegNode) {
        boardSceneDelegate?.didCollideWithBall(updatedPegNode: pegNode)
        gameState.didCollideWithBall(pegNode: pegNode)
    }
}
