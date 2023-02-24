//
//  GameFighterFactory.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

struct GameFighterFactory {
    static func getFighter(from character: GameCharacter) -> GameFighter {
        switch character {
        case .morty:
            return MortyFighter()
        case .rick:
            return RickFighter()
        }
    }
}
