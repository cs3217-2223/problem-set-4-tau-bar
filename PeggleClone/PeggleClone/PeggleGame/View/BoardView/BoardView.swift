//
//  BoardView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//
import UIKit

class BoardView: MSKView {
    func setScene(_ scene: BoardScene) {
        super.setScene(scene)
        scene.addDelegate(delegate: self)
    }
}
