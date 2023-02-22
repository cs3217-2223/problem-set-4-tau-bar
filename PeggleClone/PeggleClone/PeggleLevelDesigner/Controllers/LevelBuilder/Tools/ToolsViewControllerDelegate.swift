//
//  ToolsViewControllerDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 17/2/23.
//

import Foundation

protocol ToolsViewControllerDelegate: AnyObject {
    func didAddObject(_ object: BoardObjectWrapper)
    func didRemoveObject(_ object: BoardObjectWrapper)
    func didChangeSize(to size: Double)
    func didRotateObject(to rotation: Double)
    func didSelectObject(_ object: BoardObjectWrapper)
    func didUnselectObject()
}
