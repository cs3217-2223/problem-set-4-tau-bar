//
//  GameStateChecker.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

protocol GameState {
    var ballsLeft: Int { get set }
    var firstLabel: String? { get }
    var secondLabel: String? { get }
    var thirdLabel: String? { get }
    func isGameWon() -> Bool
    func isGameLost() -> Bool
    func didCollideWithBall(pegNode: PegNode)
    func didBallEnterBucket()
    func startGame()
}

extension GameState {
    func startGame() {
        // by default, don't need to do anything when game starts.
        // however, in future game states such as timer might need
        // to know when the game actually starts.
    }
}
