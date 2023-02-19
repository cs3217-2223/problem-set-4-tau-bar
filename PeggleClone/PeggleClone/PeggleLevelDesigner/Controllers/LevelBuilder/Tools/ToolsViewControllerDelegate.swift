//
//  ToolsViewControllerDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 17/2/23.
//

import Foundation

protocol ToolsViewControllerDelegate {
    func didAddObject(_ object: BoardObjectWrapper)
    func didRemoveObject(_ object: BoardObjectWrapper)
    func didChangeSize(of object: BoardObjectWrapper, to size: Double)
    // TODO - Add didRotateObject here as wellblue}
}
