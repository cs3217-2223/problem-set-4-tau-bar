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

    func didChangeSize(to size: Double) {
        guard let selectedObject = selectedObject else { return }
        resizeObject(selectedObject, to: size)
    }

    func didSelectObject(_ object: BoardObjectWrapper) {
        selectedObject = object
        highlightObject(object)
        actionsDelegate?.unselectAllTools()
    }

    func didUnselectObject() {
        selectedObject = nil
        unhighlightObject()
    }

    func highlightObject(_ object: BoardObjectWrapper) {
        objectsToViews.values.forEach({ view in
            if view != objectsToViews[object] {
                view.alpha = 0.5
            } else {
                view.alpha = 1
            }
        })
    }

    func unhighlightObject() {
        objectsToViews.values.forEach({ view in
            view.alpha = 1
        })
    }

}
