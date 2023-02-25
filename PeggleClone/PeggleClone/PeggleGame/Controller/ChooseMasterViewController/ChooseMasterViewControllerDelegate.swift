//
//  ChooseMasterViewControllerDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

protocol ChooseMasterViewControllerDelegate {
    func didChooseFighter(_ character: GameCharacter)
    func didStartFight()
}
