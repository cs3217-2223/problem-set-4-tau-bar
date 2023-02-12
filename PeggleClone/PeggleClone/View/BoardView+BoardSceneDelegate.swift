//
//  BoardView+BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import UIKit

extension BoardView: BoardSceneDelegate {
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
