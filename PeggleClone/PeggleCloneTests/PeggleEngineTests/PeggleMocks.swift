//
//  PeggleMocks.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

class MockPegNodeDelegate: PegNodeDelegate {
    var hasCollidedWithBall = false

    func didCollideWithBall(pegNode: PegNode) {
        hasCollidedWithBall = true
    }

}
