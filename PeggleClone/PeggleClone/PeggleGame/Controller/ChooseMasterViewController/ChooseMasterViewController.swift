//
//  ChooseMasterViewController.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import UIKit

class ChooseMasterViewController: UIViewController {
    @IBOutlet var rick: CharacterImageView!
    @IBOutlet var morty: CharacterImageView!
    @IBOutlet var fightButton: UIButton!
    var delegate: ChooseMasterViewControllerDelegate?
    var selected: UIImageView? {
        didSet {
            showSelected()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // prevents interactive dismissal of view controller
        self.isModalInPresentation = true

        let mortyGestureRecognizer = UITapGestureRecognizer(target: self,
                                                            action: #selector(imageTapped(tapGestureRecognizer:)))
        let rickGestureRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(imageTapped(tapGestureRecognizer:)))

        rick.isUserInteractionEnabled = true
        rick.addGestureRecognizer(rickGestureRecognizer)
        rick.character = .rick

        morty.isUserInteractionEnabled = true
        morty.addGestureRecognizer(mortyGestureRecognizer)
        morty.character = .morty

        select(image: rick)

    }

    @IBAction func didTapFightButton(_ sender: Any) {
        delegate?.didStartFight()
        self.dismiss(animated: true)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImage = tapGestureRecognizer.view as? CharacterImageView else {
            return
        }

        select(image: tappedImage)
    }

    func select(image: CharacterImageView) {
        guard let character = image.character else {
            return
        }
        selected = image
        delegate?.didChooseFighter(character)
    }

    func showSelected() {
        rick.alpha = 0.5
        morty.alpha = 0.5
        selected?.alpha = 1.0
    }

}
