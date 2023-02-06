//
//  BoardScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

class BoardScene: MSKScene, PegNodeDelegate {
    weak var boardView: BoardView?
    init(width: Double, height: Double) {
        super.init(physicsWorld: MSKPhysicsWorld(width: width, height: height))
    }

    func setupBoard() {
        let cannonPosition = SIMD2<Double>(x: physicsWorld.width / 2, y: 100)
        addNode(CannonNode(center: cannonPosition))
    }

    override func addNode(_ addedNode: MSKSpriteNode) {
        super.addNode(addedNode)

        guard let pegNode = addedNode as? PegNode else { return }

        pegNode.delegate = self
        boardView?.didAddPegNode(addedNode: pegNode)
    }

    func didCollideWithBall(pegNode: PegNode) {
        boardView?.didCollideWithBall(updatedPegNode: pegNode)
    }
}
