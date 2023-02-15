//
//  Constants.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//
import Foundation

enum PegColor: String {
    case blue, orange
}

let colourToImageUrl: [PegColor: String] = [PegColor.blue: "peg-blue", PegColor.orange: "peg-orange"]

func getImageUrl(from colour: PegColor) -> String? {
    colourToImageUrl[colour]
}

extension Notification.Name {
    static var objectAdded: Notification.Name {
          .init(rawValue: "Board.objectAdded") }

    static var objectDeleted: Notification.Name {
          .init(rawValue: "Board.objectDeleted") }

    static var objectMoved: Notification.Name {
          .init(rawValue: "Board.objectMoved") }

    static var boardCleared: Notification.Name {
          .init(rawValue: "Board.cleared") }

    static var dataSaved: Notification.Name {
          .init(rawValue: "Data.saved") }

    static var dataSaveError: Notification.Name {
          .init(rawValue: "Data.saveError") }
}
