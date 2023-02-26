//
//  GameFighterDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

protocol GameFighterDelegate: AnyObject {
    func createExplosionAt(pegNode: PegNode)
    func setSpookyBall(ballNode: BallNode)
}
