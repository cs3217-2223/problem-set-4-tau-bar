//
//  PegNode+PegPhysicsBodyDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension PegNode: PegPhysicsBodyDelegate {
    @objc func didCollideWithBall() {
        isHit = true
        delegate?.didCollideWithBall(pegNode: self)
    }
}
