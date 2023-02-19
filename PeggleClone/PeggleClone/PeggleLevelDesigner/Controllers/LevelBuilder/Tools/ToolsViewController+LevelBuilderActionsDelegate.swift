//
//  ToolsViewController+LevelBuilderActionsDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 17/2/23.
//

import Foundation

extension ToolsViewController: LevelBuilderActionsDelegate {
    func didTapBoardObject(_ object: BoardObjectWrapper) {
        guard let selectedButton = selectedButton else { return }

        if selectedButton === deleteButton {
            delegate?.didRemoveObject(object)
            return
        }
    }

    // TODO: Potentially refactor this
    func didTapBoard(at location: CGPoint) {
        guard let selectedButton = selectedButton else { return }

        switch selectedButton {
        case bluePegButton:
            guard let bluePeg = Peg(colour: .blue, position: location) else { return }
            let bluePegWrapper = BoardObjectWrapper(object: bluePeg)
            delegate?.didAddObject(bluePegWrapper)
            return
        case orangePegButton:
            guard let orangePeg = Peg(colour: .orange, position: location) else { return }
            let orangePegWrapper = BoardObjectWrapper(object: orangePeg)
            delegate?.didAddObject(orangePegWrapper)
            return
        case zombiePegButton:
            guard let zombiePeg = Peg(colour: .yellow, position: location) else { return }
            let zombiePegWrapper = BoardObjectWrapper(object: zombiePeg)
            delegate?.didAddObject(zombiePegWrapper)
            return
        case confusementPegButton:
            guard let confPeg = Peg(colour: .red, position: location) else { return }
            let confPegWrapper = BoardObjectWrapper(object: confPeg)
            delegate?.didAddObject(confPegWrapper)
            return
        case blockButton:
            guard let block = Block(position: location) else { return }
            let blockWrapper = BoardObjectWrapper(object: block)
            delegate?.didAddObject(blockWrapper)
            return
        default:
            return
        }
    }
}
