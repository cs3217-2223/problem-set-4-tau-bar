//
//  GameMaster.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

protocol GameFighter {
    var fighterDelegate: GameFighterDelegate? { get set }
    func performPower(pegNode: PegNode, ballNode: BallNode)
}
