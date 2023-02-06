//
//  Constants.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//
import Foundation

enum PegColour: String {
    case blue, orange
}

let colourToImageUrl: [PegColour: String] = [PegColour.blue: "peg-blue", PegColour.orange: "peg-orange"]

func getImageUrl(from colour: PegColour) -> String? {
    colourToImageUrl[colour]
}

extension Notification.Name {
    static var pegAdded: Notification.Name {
          .init(rawValue: "Board.pegAdded") }

    static var pegDeleted: Notification.Name {
          .init(rawValue: "Board.pegDeleted") }

    static var pegMoved: Notification.Name {
          .init(rawValue: "Board.pegMoved") }

    static var boardCleared: Notification.Name {
          .init(rawValue: "Board.cleared") }

    static var dataSaved: Notification.Name {
          .init(rawValue: "Data.saved") }

    static var dataSaveError: Notification.Name {
          .init(rawValue: "Data.saveError") }
}
