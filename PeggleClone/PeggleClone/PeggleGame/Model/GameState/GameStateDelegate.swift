//
//  GameStateDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 25/2/23.
//

import Foundation

protocol GameStateDelegate: AnyObject {
    func haveUnclearedBallsInGame() -> Bool
}
