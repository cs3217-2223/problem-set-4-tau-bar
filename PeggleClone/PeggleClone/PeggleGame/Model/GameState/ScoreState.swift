//
//  ScoreState.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class ScoreState: GameState {
    var firstLabel: String? {
        "Current Score:" + String(currentScore)
    }
    var secondLabel: String? {
        "Target: " + String(scoreToHit)
    }
    var thirdLabel: String? {
        guard let seconds = timer?.fireDate.timeIntervalSinceNow else { return nil }
        if seconds < 0 {
            return "0"
        }
        return String(Int(floor(seconds)))
    }

    var ballsLeft: Int
    let scoreToHit: Int
    var timeLimit: Double
    var currentScore: Int = 0
    var timer: Timer?
    var isTimerUp = false

    init(scoreToHit: Int, timeLimit: Double, ballsLeft: Int) {
        self.ballsLeft = ballsLeft
        self.scoreToHit = scoreToHit
        self.timeLimit = timeLimit
    }

    func isGameWon() -> Bool {
        currentScore >= scoreToHit
    }

    func isGameLost() -> Bool {
        // if time is up or no more balls, and score hasn't been hit -> lose
        currentScore < scoreToHit && (isTimerUp || ballsLeft == 0)
    }

    func didCollideWithBall(pegNode: PegNode) {
        if !pegNode.isHit {
            currentScore += PeggleGameConstants.getPoints(of: pegNode)
        }
    }

    func didBallEnterBucket() {
        ballsLeft += 1
        currentScore += 10
    }

    func startGame() {
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeLimit, repeats: false) { _ in
            self.isTimerUp = true
        }
    }
}
