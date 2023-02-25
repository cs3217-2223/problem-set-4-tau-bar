//
//  GameFighterDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

protocol GameFighterDelegate {
    func createExplosionAt(location: CGPoint, radius: Double)
    func setSpookyBall()
}
