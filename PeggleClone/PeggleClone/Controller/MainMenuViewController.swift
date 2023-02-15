//
//  MainMenuViewController.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 14/2/23.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet var startButton: ButtonUIImageView!
    @IBOutlet var levelDesignerButton: ButtonUIImageView!

    func segueToChooseLevel() {

    }
    @IBAction func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: goToChooseLevelViewSegue, sender: self)
    }

    @IBAction func levelDesignerButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: goToLevelBuilderViewSegue, sender: self)
    }
    
    @IBAction func unwindFromChooseLevelViewController(_ segue: UIStoryboardSegue) {}
        
    @IBAction func unwindFromLevelBuilderViewController(_ segue: UIStoryboardSegue) {}
//      TODO: Remove if unnecessary
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToChooseLevelView" {
//            guard let chooseLevelVc = segue.destination as? ChooseLevelViewController else { return }
//        }
//    }
}
