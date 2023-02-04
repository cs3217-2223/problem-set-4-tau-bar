//
//  MSKSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

protocol MSKSceneDelegate: AnyObject {
    func didRemoveNode(_ removedNode: MSKSpriteNode)
    func didAddNode(_ addedNode: MSKSpriteNode)
    func didUpdateNode(_ updatedNode: MSKSpriteNode)
}
