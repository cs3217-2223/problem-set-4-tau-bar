//
//  LevelBuilderViewController+LevelSelectViewControllerDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation

extension LevelBuilderViewController: LevelSelectViewControllerDelegate {
    // MARK: LevelSelectViewController delegate functions
    /// Loads a board from delegatee  as the board for the level builder.
    func loadBoard(_ loadedBoard: Board) {
        board = loadedBoard
    }

    func loadEmptyBoard() {
        board = createEmptyBoard()
    }
}
