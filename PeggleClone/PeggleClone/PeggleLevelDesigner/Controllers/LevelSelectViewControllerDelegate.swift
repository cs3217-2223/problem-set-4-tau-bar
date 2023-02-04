//
//  LevelSelectViewControllerDelegate.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 25/1/23.
//

protocol LevelSelectViewControllerDelegate: AnyObject {
    func loadBoard(_ board: Board)

    func loadEmptyBoard()
}
