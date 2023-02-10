//
//  BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import Foundation

protocol BoardSceneDelegate: AnyObject {
    func didCollideWithBall(updatedPegNode: PegNode)

    func didRemovePegNode(removedNode: PegNode)
}
