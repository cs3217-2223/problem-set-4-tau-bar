//
//  PreloadedLevel.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import Foundation

protocol PreloadedLevel {
    static var name: String { get set }
    static var width: Double { get set }
    static var height: Double { get set }
    static var balls: Int { get set }
    static var gameMode: GameMode { get set }
    static var objects: [BoardObjectWrapper] { get set }
}
