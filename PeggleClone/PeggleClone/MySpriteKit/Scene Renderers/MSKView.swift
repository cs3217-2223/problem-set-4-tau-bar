//
//  MSKView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import UIKit

class MSKView: UIView, MSKSceneDelegate {
    /// The scene currently presented by this view.
    var scene: MSKScene?

    /// Dictionary to cache the view representing each `MSKSpriteNode` in the `scene`.
    var nodeToView: [MSKSpriteNode: UIImageView] = [:]

    /// Presents a scene.
    func presentScene() {
        guard let nodes = scene?.nodes else { return }
        for node in nodes {
            addSubview(from: node)
        }
    }

    /// Creates a `UIImageView` from a `MSKSpriteNode`.
    func createImageView(from node: MSKSpriteNode) -> UIImageView {
        let newView = UIImageView(image: node.image)

        newView.center = node.position
        newView.frame.size = CGSize(width: node.getWidth(), height: node.getHeight())

        return newView
    }

    /// Adds a subview onto the view from a `MSKSpriteNode`.
    func addSubview(from addedNode: MSKSpriteNode) {
        let newView = createImageView(from: addedNode)
        nodeToView[addedNode] = newView
        self.addSubview(newView)
    }

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

    /// Refreshes the state of the scene to the current time.
    func refresh(timeInterval: TimeInterval) {
        scene?.update(timeInterval: timeInterval)
    }

    /// Sets the scene of the view.
    func setScene(_ scene: MSKScene) {
        self.scene = scene
    }
}
