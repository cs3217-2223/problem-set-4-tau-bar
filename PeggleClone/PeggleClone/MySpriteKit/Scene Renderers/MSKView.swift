//
//  MSKView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import UIKit

class MSKView: UIView, MSKSceneDelegate {
    var scene: MSKScene?
    var nodeToView: [MSKSpriteNode: UIView] = [:]
    func presentScene() {
        guard let nodes = scene?.nodes else { return }
        for node in nodes {
            addSubview(from: node)
        }
    }
    func createImageView(from node: MSKSpriteNode) -> UIImageView {
        let newView = UIImageView(image: node.image)
        newView.center = node.position
        // TODO: Refactor this - view shouldn't access the physicsbody.
        let nodePhysicsBody = node.physicsBody
        newView.frame.size = CGSize(width: nodePhysicsBody.getWidth(), height: nodePhysicsBody.getHeight())
        return newView
    }
    func addSubview(from addedNode: MSKSpriteNode) {
        let newView = createImageView(from: addedNode)
        nodeToView[addedNode] = newView
        self.addSubview(newView)
    }
    func didRemoveNode(_ removedNode: MSKSpriteNode) {
        nodeToView[removedNode] = nil
    }
    func didAddNode(_ addedNode: MSKSpriteNode) {
        addSubview(from: addedNode)
    }
    func didMoveNode(_ movedNode: MSKSpriteNode) {
        nodeToView[movedNode]?.center = movedNode.position
    }
    func refresh(dt: TimeInterval) {
        scene?.update(dt: dt)
    }
    func setScene(_ scene: MSKScene) {
        self.scene = scene
    }
}
