//
//  MSKView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import UIKit

class MSKView: UIView {
    /// The scene currently presented by this view.
    weak var scene: MSKScene?

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
        newView.frame = CGRect(x: node.position.x,
                               y: node.position.y,
                               width: node.getWidth(),
                               height: node.getHeight())
        newView.layer.transform = CATransform3DMakeRotation(node.angle, 0, 0, 1)
        newView.center = node.position
        return newView
    }

    /// Adds a subview onto the view from a `MSKSpriteNode`.
    func addSubview(from addedNode: MSKSpriteNode) {
        let newView = createImageView(from: addedNode)
        nodeToView[addedNode] = newView
        self.addSubview(newView)
    }

    /// Refreshes the state of the scene to the current time.
    func refresh(timeInterval: TimeInterval) {
        scene?.update(timeInterval: timeInterval)
    }

    /// Sets the scene of the view.
    func setScene(_ scene: MSKScene) {
        self.scene = scene
        self.scene?.delegate = self
    }
}
