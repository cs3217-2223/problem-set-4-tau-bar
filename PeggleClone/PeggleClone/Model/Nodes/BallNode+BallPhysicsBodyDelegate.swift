//
//  PegNode+BallPhysicsBodyDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension BallNode: BallPhysicsBodyDelegate {
    func handleBallStuck() {
        delegate?.handleBallStuck()
    }
}
