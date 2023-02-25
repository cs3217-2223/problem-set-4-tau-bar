//
//  MSKNode+MSKPhysicsBodyDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension MSKNode: MSKPhysicsBodyDelegate {
    /// Updates position of node when position of physics body gets updated.
    /// Delegate function for `MSKPhysicsBodyDelegate`.
    func didUpdatePosition() {
        updatePosition()
    }

    private func updatePosition() {
        position.x = physicsBody.position.x
        position.y = physicsBody.position.y
    }
}
