//
//  Board+FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation

/// `Board` can't directly conform to `FetchedData`, so instead we create a custom function to
/// convert from Core Data type to `Board`.
extension Board {
    static func createBoard(with data: BoardData) throws -> Board {
        guard let blockSet = data.blockDatas else {
            throw StorageError.invalidBoardData
        }

        guard let pegSet = data.pegDatas else {
            throw StorageError.invalidBoardData
        }

        let pegDatas = pegSet.compactMap({ $0 as? PegData })
        let blockDatas = blockSet.compactMap({ $0 as? BlockData })

        guard let name = data.name else {
            throw StorageError.invalidBoardData
        }

        guard let gameModeData = data.gameModeData else {
            throw StorageError.invalidGameMode
        }

        let board = Board(objects: Set(), width: data.width, height: data.height, name: name)
        board.balls = Int(data.balls)
        board.gameMode = try GameMode(data: gameModeData)

        try populateBoard(pegDatas: pegDatas, blockDatas: blockDatas, board: board)

        return board
    }

    private static func populateBoard(pegDatas: [PegData], blockDatas: [BlockData], board: Board) throws {
        try pegDatas.forEach({ pegData in
            let peg = try Peg.createPeg(with: pegData)
            board.objects.insert(BoardObjectWrapper(object: peg))
        })

        try blockDatas.forEach({ blockData in
            let block = try Block.createBlock(with: blockData)
            board.objects.insert(BoardObjectWrapper(object: block))
        })
    }
}
