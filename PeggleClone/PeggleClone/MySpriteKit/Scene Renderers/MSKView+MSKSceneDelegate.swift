//
//  MSKView+MSKSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import UIKit

extension MSKView: MSKSceneDelegate {
    /// Removes a subview which represents a `MSKSpriteNode`.
    func didRemoveNode(_ removedNode: MSKSpriteNode) {
        nodeToView[removedNode]?.removeFromSuperview()
        nodeToView[removedNode] = nil
    }

    /// Adds a subview when a `MSKSpriteNode` is added to the scene.
    func didAddNode(_ addedNode: MSKSpriteNode) {
        addSubview(from: addedNode)
    }

    /// Updates a subview to the latest state of the `MSKSpriteNode`.
    func didUpdateNode(_ node: MSKSpriteNode) {
        nodeToView[node]?.center = node.position
    }

    func didRotateNode(_ node: MSKSpriteNode) {
        nodeToView[node]?.transform = CGAffineTransformMakeRotation(node.angle)
    }
    
    func didUpdateNodeImage(_ node: MSKSpriteNode) {
        nodeToView[node]?.image = node.image
    }
}
