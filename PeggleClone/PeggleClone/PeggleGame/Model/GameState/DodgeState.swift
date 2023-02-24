//
//  DodgeState.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class DodgeState: GameState {
    var firstLabel: String? {
        "Chances Left:" + String(ballsWithoutHittingLeft)
    }
    var secondLabel: String?
    var thirdLabel: String?

    var ballsLeft: Int {
        didSet {
            // when scene subtracts balls left, update the ballsWithoutHittingLeft & hasBallHitPeg
            if hasBallHitPeg {
                ballsWithoutHittingLeft -= 1
                hasBallHitPeg = false
            }
        }
    }
    var ballsWithoutHittingLeft: Int
    var hasBallHitPeg: Bool

    init(ballsWithoutHittingLeft: Int, ballsLeft: Int) {
        self.ballsWithoutHittingLeft = ballsWithoutHittingLeft
        self.ballsLeft = ballsLeft
        self.hasBallHitPeg = false
    }

    func isGameWon() -> Bool {
        ballsLeft == 0 && ballsWithoutHittingLeft > 0
    }

    func isGameLost() -> Bool {
        ballsLeft == 0 && ballsWithoutHittingLeft <= 0
    }

    func didCollideWithBall(pegNode: PegNode) {
        if !pegNode.isHit {
            hasBallHitPeg = true
        }
    }

    func didBallEnterBucket() {
        ballsWithoutHittingLeft += 1
    }
}
