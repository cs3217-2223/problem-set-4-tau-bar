//
//  BoardView+BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import UIKit

extension BoardView: BoardSceneDelegate {
    func didHitBallFirstTime(pegNode: PegNode) {
        // add a ui indicator of how many points obtained
        let points = PeggleGameConstants.getPoints(of: pegNode)
        addDescriptorText(string: String(points), at: pegNode.position)
    }

    func addDescriptorText(string: String, at location: CGPoint) {
        let label = UILabel()
        label.text = string
        label.frame = CGRect(x: location.x, y: location.y + 10, width: 100, height: 30)
        label.alpha = 0
        label.font = UIFont(name: "HiraginoSans-bold", size: 14.0)
        addSubview(label)
        label.fadeIn(duration: 0.5, completion: { (_: Bool) -> Void in
            // when fade out is complete, remove from superview
            label.fadeOut(duration: 0.5, delay: 0.5, completion: { (_: Bool) -> Void in
                label.removeFromSuperview()
            })
        })
    }

    func didFireCannon() {
        // TOOD: add something here
    }

    func didEnterBucket(gameState: GameState, at location: CGPoint) {
        let newPos = CGPoint(x: location.x, y: location.y - 100)
        addDescriptorText(string: gameState.enterBucketDescriptor, at: newPos)
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

    func didAddExplosion(at location: CGPoint, duration: TimeInterval, radius: Double) {
        let explosionImageView = UIImageView()
        let size = PeggleGameConstants.defaultExplosionRadius * 2
        explosionImageView.frame = CGRect(x: location.x, y: location.y, width: size, height: size)
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
