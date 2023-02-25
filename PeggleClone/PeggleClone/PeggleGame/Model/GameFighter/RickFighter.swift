//
//  RickFighter.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

struct RickFighter: GameFighter {
    var fighterDelegate: GameFighterDelegate?

    func performPower(pegNode: PegNode, ballNode: BallNode) {
        fighterDelegate?.setSpookyBall(ballNode: ballNode)
    }
}
