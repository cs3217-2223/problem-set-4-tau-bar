//
//  BoardScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

class BoardScene: MSKScene {
    init(width: Double, height: Double) {
        super.init(physicsWorld: MSKPhysicsWorld(width: width, height: height))
    }
}
