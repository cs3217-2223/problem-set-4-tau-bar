//
//  BoardView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//
import UIKit

class BoardView: MSKView, BoardSceneDelegate {
    func setScene(_ scene: BoardScene) {
        super.setScene(scene)
        scene.boardSceneDelegate = self
        scene.setupBoard()
    }

    func didCollideWithBall(updatedPegNode: PegNode) {
        nodeToView[updatedPegNode]?.image = updatedPegNode.image
    }

    func didRemovePegNode(removedNode: PegNode) {
        let viewToRemove = nodeToView[removedNode]
        UIView.animate(withDuration: 0.5,
                       animations: { viewToRemove?.alpha = 0 },
                       completion: { _ in viewToRemove?.removeFromSuperview() })
    }
}
