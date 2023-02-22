//
//  LevelBuilderActionsDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 17/2/23.
//

import Foundation

protocol LevelBuilderActionsDelegate {
    func didTapBoardObject(_ object: BoardObjectWrapper)
    func didTapBoard(at location: CGPoint)
    func unselectAllTools()
}
