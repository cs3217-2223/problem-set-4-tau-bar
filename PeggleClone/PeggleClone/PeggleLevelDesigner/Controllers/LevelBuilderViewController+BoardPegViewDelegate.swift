//
//  LevelBuilderViewController+BoardPegViewDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import UIKit

extension LevelBuilderViewController: BoardObjectViewDelegate {
    // MARK: Delegate functions for `BoardObjectView`
    /// Deletes a board object that was long pressed from the level.
    /// Delegate function for long press on `BoardObjectView`.
    func userDidLongPress(boardObjectView: BoardObjectView) {
        deleteObject(of: boardObjectView)
    }

    /// Deletes a board object from the level if the user taps on it and if the delete peg button is selected.
    /// Otherwise, do nothing.
    /// Delegate function for tap on `BoardObjectView`.
    func userDidTap(boardObjectView: BoardObjectView) {
        if isDeletePegButton(selectedButton: selectedButton) {
            deleteObject(of: boardObjectView)
        }
    }

    /// Moves a peg on the board that was panned to the new location on the level if valid.
    /// Otherwise, do nothing.
    /// Delegate function for pan on `BoardObjectView`.
    func userDidPan(sender: UIPanGestureRecognizer) {
        moveObject(of: sender)
    }
}
