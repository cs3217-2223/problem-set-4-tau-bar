//
//  BoardScene+BallNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension BoardScene: BallNodeDelegate {
    func handleBallStuck() {
        removeHitPegs()
    }
}
