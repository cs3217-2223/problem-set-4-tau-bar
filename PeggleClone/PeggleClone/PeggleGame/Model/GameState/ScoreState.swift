//
//  ScoreState.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class ScoreState: GameState {
    var ballsLeft: Int
    let scoreToHit: Int
    var timeLeft: Double
    var currentScore: Int = 0

    init(scoreToHit: Int, timeLimit: Double, ballsLeft: Int) {
        self.ballsLeft = ballsLeft
        self.scoreToHit = scoreToHit
        self.timeLeft = timeLimit
    }

    func isGameWon() -> Bool {
        currentScore >= scoreToHit
    }

    func isGameLost() -> Bool {
        // if time is up or no more balls, and score hasn't been hit -> lose
        currentScore < scoreToHit && (timeLeft <= 0 || ballsLeft == 0)
    }

    func didCollideWithBall(pegNode: PegNode) {
        if !pegNode.isHit {
            currentScore += PeggleGameConstants.getPoints(of: pegNode)
        }
    }

    func didBallEnterBucket() {
        ballsLeft += 1
        currentScore += 1_000
    }
}
