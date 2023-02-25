//
//  MortyFighter.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

struct MortyFighter: GameFighter {
    let defaultExplosionRadius: Double = 150
    var fighterDelegate: GameFighterDelegate?

    func performPower(at location: CGPoint) {
        fighterDelegate?.createExplosionAt(location: location, radius: defaultExplosionRadius)
    }
}
