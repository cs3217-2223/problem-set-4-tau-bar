//
//  MSKRenderer.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import CoreGraphics
import QuartzCore

class MSKRenderer {
    var view: MSKView
    var displayLink: CADisplayLink!
    init(view: MSKView) {
        self.view = view
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        self.displayLink.add(to: .current, forMode: RunLoop.Mode.default)
    }
    func begin() {
        view.presentScene()
    }
    @objc func step() {
        view.refresh(dt: displayLink.targetTimestamp - displayLink.timestamp)
    }
}
