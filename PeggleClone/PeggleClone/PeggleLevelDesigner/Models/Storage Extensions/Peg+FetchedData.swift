//
//  Peg+FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation

/// `Peg` can't directly conform to `FetchedData`, so instead we create a custom function to
/// convert from Core Data type to Peg.
extension Peg {
    static func createPeg(with data: PegData) throws -> Peg {
        guard let position = data.positionData,
              let color = data.colorData else {
            throw StorageError.invalidPegData
        }

        let pegPosition = try CGPoint(data: position)
        let pegColor = try PegColor(data: color)
        guard let asset = Self.pegAssets[pegColor] else {
            throw StorageError.invalidPegColor
        }

        let peg = Peg(color: pegColor,
                           position: pegPosition,
                           rotation: data.rotation,
                           radius: data.radius,
                           asset: asset)

        return peg
    }
}
