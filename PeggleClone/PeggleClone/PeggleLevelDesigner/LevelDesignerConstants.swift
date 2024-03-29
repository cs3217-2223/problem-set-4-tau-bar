//
//  Constants.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//
import Foundation

extension Notification.Name {
    static var objectAdded: Notification.Name {
          .init(rawValue: "Board.objectAdded") }

    static var objectDeleted: Notification.Name {
          .init(rawValue: "Board.objectDeleted") }

    static var objectMoved: Notification.Name {
          .init(rawValue: "Board.objectMoved") }

    static var objectResizeSuccess: Notification.Name {
          .init(rawValue: "Board.objectResizeSuccess") }

    static var objectResizeFail: Notification.Name {
          .init(rawValue: "Board.objectResizeFail") }

    static var boardCleared: Notification.Name {
          .init(rawValue: "Board.cleared") }
}
