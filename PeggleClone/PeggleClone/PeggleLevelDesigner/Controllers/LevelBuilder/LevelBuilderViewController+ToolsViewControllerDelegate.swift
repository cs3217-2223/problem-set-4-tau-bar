//
//  LevelBuilderViewController+ToolsViewControllerDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 17/2/23.
//

import Foundation

extension LevelBuilderViewController: ToolsViewControllerDelegate {
    func didAddObject(_ object: BoardObjectWrapper) {
        addObject(addedObjectWrapper: object)
    }

    func didRemoveObject(_ object: BoardObjectWrapper) {
        board?.removeObject(object)
    }

    func didChangeSize(of object: BoardObjectWrapper, to size: Double) {
        // TODO - Add implementation --> need to add implementation into board as well to ensure that cannot change size if overlap/out of bounds
    }

}
