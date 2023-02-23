//
//  GameMode+FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

extension GameMode: FetchedData {
    init(data: GameModeData) throws {
        guard let mode = data.mode,
              let gameMode = GameMode(rawValue: mode) else {
            throw StorageError.invalidGameMode
        }
        self = gameMode
    }

}
