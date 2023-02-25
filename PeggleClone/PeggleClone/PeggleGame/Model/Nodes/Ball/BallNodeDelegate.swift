//
//  BallNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 11/2/23.
//

import Foundation

protocol BallNodeDelegate: AnyObject {
    func handleBallStuck()

    func didChangeSpooky(ballNode: BallNode)
}
