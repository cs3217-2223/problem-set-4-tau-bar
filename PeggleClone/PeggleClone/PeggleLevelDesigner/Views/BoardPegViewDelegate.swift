//
//  BoardPegDelegate.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 23/1/23.
//

import UIKit

protocol BoardPegViewDelegate: AnyObject {
    func userDidLongPress(boardPegView: BoardPegView)

    func userDidTap(boardPegView: BoardPegView)

    func userDidPan(sender: UIPanGestureRecognizer)
}
