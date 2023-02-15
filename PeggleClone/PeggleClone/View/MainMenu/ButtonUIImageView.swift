//
//  ButtonUIImageView.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 14/2/23.
//

import UIKit

class ButtonUIImageView: UIImageView {
    var tapHandler: (() -> Void)?

    private func setup() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapStartButton))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func didTapStartButton() {
        guard let tapHandler = tapHandler else {
            return
        }
        tapHandler()
    }
}
