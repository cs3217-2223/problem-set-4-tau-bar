//
//  LevelBuilderViewController+BoardPegViewDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import UIKit

extension LevelBuilderViewController: BoardPegViewDelegate {
    // MARK: Delegate functions for `BoardPegView`
    /// Deletes a board peg that was long pressed from the level.
    /// Delegate function for long press on `BoardPegView`.
    func userDidLongPress(boardPegView: BoardPegView) {
        deletePeg(of: boardPegView)
    }

    /// Deletes a board peg from the level if the user taps on it and if the delete peg button is selected.
    /// Otherwise, do nothing.
    /// Delegate function for tap on `BoardPegView`.
    func userDidTap(boardPegView: BoardPegView) {
        if isDeletePegButton(selectedButton: selectedButton) {
            deletePeg(of: boardPegView)
        }
    }

    /// Moves a peg on the board that was panned to the new location on the level if valid.
    /// Otherwise, do nothing.
    /// Delegate function for pan on `BoardPegView`.
    func userDidPan(sender: UIPanGestureRecognizer) {
        movePeg(of: sender)
    }
}
