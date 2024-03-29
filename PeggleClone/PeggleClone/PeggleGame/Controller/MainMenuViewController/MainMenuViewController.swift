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
    var musicPlayer: MusicPlayer?

    // Data Manager
    let dataManager = DataManager()

    override func viewDidAppear(_ animated: Bool) {
        musicPlayer = MusicPlayer()
        musicPlayer?.startBackgroundMusic()
    }

    override func viewDidLoad() {
        do {
            let loadLevels = LoadLevels(dataManager: dataManager)
            try loadLevels.loadPreloadedLevels()
        } catch {
            print("Could not load pre-loaded levels.")
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        musicPlayer?.stopBackgroundMusic()
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
