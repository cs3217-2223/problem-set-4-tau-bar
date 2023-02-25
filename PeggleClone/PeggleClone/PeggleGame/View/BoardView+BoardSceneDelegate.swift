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

    func didAddExplosion(at location: CGPoint, duration: TimeInterval, radius: Double) {
        let explosionImageView = UIImageView()
        explosionImageView.frame = CGRect(x: location.x, y: location.y, width: 500, height: 500)
        explosionImageView.center = location
        var explosionImages: [UIImage] = []
        for idx in 0...10 {
            let assetName = "explosion_" + String(idx)
            guard let image = UIImage(named: assetName) else { continue }
            explosionImages.append(image)
        }
        explosionImageView.animationImages = explosionImages
        explosionImageView.animationDuration = duration
        explosionImageView.animationRepeatCount = 1
        addSubview(explosionImageView)
        explosionImageView.startAnimating()
    }
}
