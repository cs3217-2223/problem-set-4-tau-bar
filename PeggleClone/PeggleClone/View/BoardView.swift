//
//  BoardView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//
import UIKit

class BoardView: MSKView, BoardSceneDelegate {
    func didCollideWithBall(updatedPegNode: PegNode) {
        nodeToView[updatedPegNode]?.image = updatedPegNode.image
    }

    override func setScene(_ scene: MSKScene) {
        super.setScene(scene)
        guard let boardScene = scene as? BoardScene else { return }
        boardScene.boardView = self
        boardScene.setupBoard()
    }

    func fadeOutPegView(removedNode: PegNode) {
        let viewToRemove = nodeToView[removedNode]
        UIView.animate(withDuration: 0.5,
                       animations: { viewToRemove?.alpha = 0 },
                       completion: { _ in viewToRemove?.removeFromSuperview() })
    }
}
