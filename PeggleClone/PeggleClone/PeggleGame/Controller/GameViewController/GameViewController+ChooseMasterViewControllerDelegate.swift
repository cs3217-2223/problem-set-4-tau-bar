//
//  GameViewController+ChooseMasterViewControllerDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation

extension GameViewController: ChooseMasterViewControllerDelegate {
    func didChooseFighter(_ character: GameCharacter) {
        gameFighter = GameFighterFactory.getFighter(from: character)
    }

    func didStartFight() {
        boardView.presentScene()
        startGameLoop()
        boardScene?.begin()
    }

}
