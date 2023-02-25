//
//  MortyFighter.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

struct MortyFighter: GameFighter {
    var fighterDelegate: GameFighterDelegate?

    func performPower(pegNode: PegNode, ballNode: BallNode) {
        fighterDelegate?.createExplosionAt(pegNode: pegNode)
    }
}
