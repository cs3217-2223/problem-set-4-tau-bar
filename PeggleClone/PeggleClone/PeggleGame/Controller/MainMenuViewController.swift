//
//  MainMenuViewController.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 14/2/23.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var levelDesignerButton: UIButton!
    
    override func viewDidLoad() {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: goToChooseLevelViewSegue, sender: self)
    }

    @IBAction func levelDesignerButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: goToLevelBuilderViewSegue, sender: self)
    }

    @IBAction func unwindFromChooseLevelViewController(_ segue: UIStoryboardSegue) {}

    @IBAction func unwindFromLevelBuilderViewController(_ segue: UIStoryboardSegue) {}
}
