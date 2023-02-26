//
//  LavelBuilderViewController+Alerts.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import UIKit

extension LevelBuilderViewController {
    /// Presents an alert to user that no level name was entered.
    func alertUserNoName() {
        let alert = UIAlertController(title: "No name", message: "Please enter level name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in NSLog("The alertUserNoName alert occured.") }))
        self.present(alert, animated: true, completion: nil)
    }

    /// Presents an alert to inform user that level has saved.
    func alertUserLevelSaved() {
        let alert = UIAlertController(title: "Level saved", message: "Your level is saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in NSLog("The alertUserLevelSaved alert occured.") }))
        self.present(alert, animated: true, completion: nil)
    }

    func alertUserSaveError() {
        let alert = UIAlertController(title: "Error while saving",
                                      message: "There was an error saving your level.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in NSLog("The alertUserSaveError alert occured.") }))
        self.present(alert, animated: true, completion: nil)
    }
}
