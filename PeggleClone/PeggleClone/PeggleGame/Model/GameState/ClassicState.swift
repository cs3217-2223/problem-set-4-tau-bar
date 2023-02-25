//
//  ClassicChecker.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class ClassicState: GameState {
    var delegate: GameStateDelegate?

    var firstLabel: String? {
        "Orange Pegs Left: " + String(orangePegsLeft)
    }
    var secondLabel: String?
    var thirdLabel: String?

    var orangePegsLeft: Int
    var ballsLeft: Int

    init(initialOrangePegs: Int, initialBalls: Int) {
        orangePegsLeft = initialOrangePegs
        ballsLeft = initialBalls
    }

    func isGameWon() -> Bool {
        orangePegsLeft == 0
    }

    func isGameLost() -> Bool {
        orangePegsLeft > 0 && ballsLeft == 0 && !(delegate?.haveUnclearedBallsInGame() ?? true)
    }

    func didCollideWithBall(pegNode: PegNode) {
        if pegNode is OrangePegNode, !pegNode.isHit {
            orangePegsLeft -= 1
        }
    }

    func didBallEnterBucket() {
        ballsLeft += 1
    }
}
