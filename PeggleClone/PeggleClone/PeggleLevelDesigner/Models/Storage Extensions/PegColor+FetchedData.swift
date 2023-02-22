//
//  PegColor+FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation

extension PegColor: FetchedData {
    init(data: PegColorData) throws {
        guard let color = data.color,
              let pegColor = PegColor(rawValue: color) else {
            throw StorageError.invalidPegColor
        }
        self = pegColor
    }

}
