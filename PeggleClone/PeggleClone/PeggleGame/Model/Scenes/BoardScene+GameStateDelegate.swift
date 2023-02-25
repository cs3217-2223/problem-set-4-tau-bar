//
//  BoardScene+GameStateDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 25/2/23.
//

import Foundation

extension BoardScene: GameStateDelegate {
    func haveUnclearedBallsInGame() -> Bool {
        nodes.contains(where: { type(of: $0) == BallNode.self })
    }
}
