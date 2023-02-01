//
//  MSKSpriteNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import UIKit

class MSKSpriteNode: MSKNode {
    var image: UIImage
    init(position: CGPoint, physicsBody: MSKPhysicsBody, image: UIImage) {
        self.image = image
        super.init(position: position, physicsBody: physicsBody)
    }
}
