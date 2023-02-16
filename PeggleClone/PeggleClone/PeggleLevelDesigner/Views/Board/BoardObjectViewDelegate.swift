//
//  BoardPegDelegate.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 23/1/23.
//

import UIKit

protocol BoardObjectViewDelegate: AnyObject {
    func userDidLongPress(boardObjectView: BoardObjectView)

    func userDidTap(boardObjectView: BoardObjectView)

    func userDidPan(sender: UIPanGestureRecognizer)
}
