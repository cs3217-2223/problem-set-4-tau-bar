//
//  PegNodeDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 6/2/23.
//

import Foundation

protocol PegNodeDelegate: AnyObject {
    func didCollideWithBall(pegNode: PegNode)
    func didActivatePower(pegNode: PegNode)
    func didGlow(pegNode: PegNode)
}
