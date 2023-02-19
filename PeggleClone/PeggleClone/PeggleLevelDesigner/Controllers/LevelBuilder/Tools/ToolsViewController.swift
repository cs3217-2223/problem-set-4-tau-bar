//
//  ToolsViewController.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 17/2/23.
//

import Foundation
import UIKit

class ToolsViewController: UIViewController {

    @IBOutlet var deleteButton: ToolButton!
    @IBOutlet var confusementPegButton: ToolButton!
    @IBOutlet var zombiePegButton: ToolButton!
    @IBOutlet var blockButton: ToolButton!
    @IBOutlet var bluePegButton: ToolButton!
    @IBOutlet var orangePegButton: ToolButton!
    var selectedButton: ToolButton? {
        didSet {
            setButtonsTranslucent()
            guard let newSelected = selectedButton else { return }
            setSelectedButtonOpaque(selected: newSelected)
        }
    }

    override func viewDidLoad() {
        selectedButton = orangePegButton
    }

    // TODO - Ensure no strong reference cycles
    var delegate: ToolsViewControllerDelegate?

    @IBAction func didTapToolButton(_ sender: Any) {
        guard let tappedButton = sender as? ToolButton else { return }
        selectedButton = tappedButton
    }

    func setButtonsTranslucent() {
        deleteButton.alpha = ToolButton.unselectedAlphaValue
        confusementPegButton.alpha = ToolButton.unselectedAlphaValue
        zombiePegButton.alpha = ToolButton.unselectedAlphaValue
        blockButton.alpha = ToolButton.unselectedAlphaValue
        bluePegButton.alpha = ToolButton.unselectedAlphaValue
        orangePegButton.alpha = ToolButton.unselectedAlphaValue
    }

    func setSelectedButtonOpaque(selected: ToolButton) {
        selected.alpha = ToolButton.selectedAlphaValue
    }

}
