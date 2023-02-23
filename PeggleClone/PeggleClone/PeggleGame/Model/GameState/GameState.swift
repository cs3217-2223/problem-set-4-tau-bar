//
//  GameStateChecker.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

protocol GameState {
    var ballsLeft: Int { get set }
    func isGameWon() -> Bool
    func isGameLost() -> Bool
    func didCollideWithBall(pegNode: PegNode)
}
