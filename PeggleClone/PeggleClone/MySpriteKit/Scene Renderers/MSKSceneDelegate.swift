//
//  MSKSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

/// The `MSKSceneDelegate` should be conformed to by a class which is visually representing the scene,
/// such as the positions of the nodes, etc.
protocol MSKSceneDelegate: AnyObject {
    func didRemoveNode(_ removedNode: MSKSpriteNode)

    func didAddNode(_ addedNode: MSKSpriteNode)

    func didUpdateNode(_ node: MSKSpriteNode)

    func didRotateNode(_ node: MSKSpriteNode)
    
    func didUpdateNodeImage(_ node: MSKSpriteNode)
}
