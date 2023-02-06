//
//  BoardView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//
import UIKit

class BoardView: MSKView, BoardSceneDelegate {
    var pegToView: [PegNode: UIImageView] = [:]

    func didCollideWithBall(updatedPegNode: PegNode) {
        pegToView[updatedPegNode]?.image = updatedPegNode.image
    }

    func didAddPegNode(addedNode: PegNode) {
        pegToView[addedNode] = nodeToView[addedNode]
    }

    override func setScene(_ scene: MSKScene) {
        super.setScene(scene)
        guard let boardScene = scene as? BoardScene else { return }
        boardScene.boardView = self
    }
}
