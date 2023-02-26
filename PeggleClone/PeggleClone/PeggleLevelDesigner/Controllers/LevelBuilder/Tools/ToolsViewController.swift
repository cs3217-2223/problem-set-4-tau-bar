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
    @IBOutlet var greenPegButton: ToolButton!

    @IBOutlet var sizeSlider: UISlider!
    @IBOutlet var sizeLabel: UILabel!

    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var rotationLabel: UILabel!

    @IBOutlet var stepper: UIStepper!

    var selectedButton: ToolButton? {
        didSet {
            setButtonsTranslucent()
            guard let newSelected = selectedButton else { return }
            setSelectedButtonOpaque(selected: newSelected)
        }
    }

    override func viewDidLoad() {
        selectedButton = orangePegButton

        sizeSlider.minimumValue = 15.0
        sizeSlider.maximumValue = 60.0

        angleSlider.minimumValue = -.pi
        angleSlider.maximumValue = .pi

        stepper.stepValue = 0.1

        hideObjectSpecificTools()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetSizeSlider),
                                               name: .objectResizeFail,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetAngleSlider),
                                               name: .objectRotateFail,
                                               object: nil)
    }

    weak var delegate: ToolsViewControllerDelegate?

    @IBAction func didTapToolButton(_ sender: Any) {
        guard let tappedButton = sender as? ToolButton else { return }
        selectedButton = tappedButton
        unselectObject()
    }

    @IBAction func didChangeSize(_ sender: Any) {
        delegate?.didChangeSize(to: Double(sizeSlider.value))
    }

    @IBAction func didChangeRotation(_ sender: UISlider) {
        delegate?.didRotateObject(to: Double(angleSlider.value))
    }

    @IBAction func didChangeStepper(_ sender: Any) {
        delegate?.didRotateObject(to: Double(stepper.value))
    }

    func setButtonsTranslucent() {
        deleteButton.alpha = ToolButton.unselectedAlphaValue
        confusementPegButton.alpha = ToolButton.unselectedAlphaValue
        zombiePegButton.alpha = ToolButton.unselectedAlphaValue
        blockButton.alpha = ToolButton.unselectedAlphaValue
        bluePegButton.alpha = ToolButton.unselectedAlphaValue
        orangePegButton.alpha = ToolButton.unselectedAlphaValue
        greenPegButton.alpha = ToolButton.unselectedAlphaValue
    }

    func setSelectedButtonOpaque(selected: ToolButton) {
        selected.alpha = ToolButton.selectedAlphaValue
    }

    func hideObjectSpecificTools() {
        sizeSlider.alpha = 0
        sizeLabel.alpha = 0
        rotationLabel.alpha = 0
        angleSlider.alpha = 0
    }

    func showObjectSpecificTools(for object: BoardObjectWrapper) {
        sizeSlider.value = Float(Double(object.object.width))
        sizeSlider.alpha = 1
        sizeLabel.alpha = 1

        angleSlider.value = Float(Double(object.object.rotation))
        angleSlider.alpha = 1
        rotationLabel.alpha = 1
    }

    func unselectObject() {
        delegate?.didUnselectObject()
        hideObjectSpecificTools()
    }

    @objc func resetSizeSlider(_ notification: Notification) {
        guard let resizedObjectWrapper = notification.object as? BoardObjectWrapper
        else {
            return
        }

        let oldValue = resizedObjectWrapper.object.width
        sizeSlider.setValue(Float(oldValue), animated: false)
    }

    @objc func resetAngleSlider(_ notification: Notification) {
        guard let rotatedObjectWrapper = notification.object as? BoardObjectWrapper
        else {
            return
        }

        let oldValue = rotatedObjectWrapper.object.rotation
        angleSlider.setValue(Float(oldValue), animated: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .objectRotateFail, object: nil)
        NotificationCenter.default.removeObserver(self, name: .objectResizeFail, object: nil)
    }

}
