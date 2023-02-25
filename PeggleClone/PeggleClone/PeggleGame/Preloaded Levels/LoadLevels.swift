//
//  LoadLevels.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import UIKit

class LoadLevels {
    let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func loadPreloadedLevels() throws {
        let board1 = createBoard(DefaultLevelOne.self)
        try dataManager.save(board: board1, overwrite: true)

        let board2 = createBoard(DefaultLevelTwo.self)
        try dataManager.save(board: board2, overwrite: true)

        let board3 = createBoard(DefaultLevelThree.self)
        try dataManager.save(board: board3, overwrite: true)
    }

    func createBoard(_ level: PreloadedLevel.Type) -> Board {
        let newWidth = PeggleGameConstants.boardWidth
        let newHeight = PeggleGameConstants.boardHeight
        let board = Board(objects: Set(),
                          width: level.width,
                          height: level.height,
                          name: level.name,
                          balls: level.balls,
                          gameMode: level.gameMode)
        board.objects = Set(level.objects.map({
            convertObject(oldHeight: level.height,
                          oldWidth: level.width,
                          newHeight: newWidth,
                          newWidth: newHeight,
                          obj: $0)
        }))

        return board
    }

    func convertObject(oldHeight: Double,
                       oldWidth: Double,
                       newHeight: Double,
                       newWidth: Double,
                       obj: BoardObjectWrapper) -> BoardObjectWrapper {
        let widthRatio = newWidth / oldWidth
        let heightRatio = newHeight / oldHeight
        let multiplier: Double = min(heightRatio, widthRatio)
        if let peg = obj.object as? Peg {
            peg.radius *= multiplier
            peg.position.x *= widthRatio
            peg.position.y *= heightRatio
        } else if let block = obj.object as? Block {
            block.width *= multiplier
            block.height *= multiplier
            block.position.x *= widthRatio
            block.position.y *= heightRatio
        }
        return obj
    }
}
