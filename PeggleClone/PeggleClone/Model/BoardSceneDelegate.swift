//
//  BoardSceneDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import Foundation

protocol BoardSceneDelegate {
    func didCollideWithBall(updatedPegNode: PegNode)

    func didAddPegNode(addedNode: PegNode)
}
