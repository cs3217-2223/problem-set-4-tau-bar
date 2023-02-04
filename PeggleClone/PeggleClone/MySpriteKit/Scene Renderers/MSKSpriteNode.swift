//
//  MSKSpriteNode.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 1/2/23.
//

import UIKit

class MSKSpriteNode: MSKNode {
    var image: UIImage?
    init(physicsBody: MSKPhysicsBody, image: UIImage?) {
        self.image = image
        super.init(physicsBody: physicsBody)
    }
}
