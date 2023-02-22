//
//  Block+FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation

/// `Block` can't directly conform to `FetchedData`, so instead we create a custom function to
/// convert from Core Data type to `Block`.
extension Block {
    static func createBlock(with data: BlockData) throws -> Block {
        guard let position = data.positionData else {
            throw StorageError.invalidBlockData
        }

        let blockPosition = try CGPoint(data: position)

        guard let block = Block(position: blockPosition,
                          rotation: data.rotation,
                          height: data.height,
                                width: data.height) else {
            throw StorageError.invalidBlockData
        }

        return block
    }
}
