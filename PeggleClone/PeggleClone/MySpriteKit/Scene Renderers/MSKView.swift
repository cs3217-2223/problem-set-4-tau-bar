//
//  MSKView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import UIKit

class MSKView: UIView {
    var scene: MSKScene?
    func presentScene() {
        guard let nodes = scene?.nodes else { return }
        for node in nodes {
            let newView = createImageView(from: node)
            self.addSubview(newView)
        }
    }
    func createImageView(from node: MSKSpriteNode) -> UIImageView {
        let newView = UIImageView(image: node.image)
        newView.center = node.position
        return newView
    }
}
