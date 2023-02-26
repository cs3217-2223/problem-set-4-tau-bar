//
//  DefaultLevelThree.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import Foundation

/// This level was generated using an iPad Pro.
class DefaultLevelThree: PreloadedLevel {
    static var width: Double = 1_004
    static var height: Double = 1_080
    static var balls: Int = 1
    static var gameMode: GameMode = .dodge
    static var name = "LEVEL 3"
    static var objects = [BoardObjectWrapper(object: Block(position: CGPoint(x: 31.0, y: 330.5),
                                                    rotation: 0.7222051024436951,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 336.5,
                                                                                                      y: 595.0),
                                                    rotation: 0.6860950589179993,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 453.0, y: 112.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                    position: CGPoint(x: 144.5, y: 1_058.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-green")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                    position: CGPoint(x: 64.0, y: 1_058.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-green")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 58.0, y: 248.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 519.0, y: 45.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 251.0,
                                                                                                      y: 517.0),
                                                    rotation: 0.7583154439926147,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 121.0, y: 140.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 211.0,
                                                                                                      y: 478.5),
                                                    rotation: 0.7583154439926147,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 193.5, y: 45.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 165.0,
                                                                                                      y: 441.0),
                                                    rotation: 0.7944258451461792,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 487.0, y: 75.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 32.5, y: 284.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 160.0, y: 70.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 412.0, y: 134.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.red,
                                                    position: CGPoint(x: 394.5, y: 514.0),
                                                    rotation: 0.0,
                                                    radius: 30.0,
                                                    asset: "peg-red")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 98.5, y: 175.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 294.0,
                                                                                                      y: 556.0),
                                                    rotation: 0.8666461706161499,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                    position: CGPoint(x: 22.0, y: 1_057.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-green")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 553.5, y: 24.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 379.5, y: 160.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 321.0, y: 216.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 117.5, y: 407.0),
                                                    rotation: 0.7222051024436951,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                    position: CGPoint(x: 104.0, y: 1_059.5),
                                                    rotation: 0.8666461706161499,
                                                    radius: 20.0,
                                                    asset: "peg-blue")),
                                                   BoardObjectWrapper(object: Block(position: CGPoint(x: 73.0,
                                                                                                      y: 369.5),
                                                    rotation: 0.7583154439926147,
                                                    height: 40.0,
                                                    width: 40.0)),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 82.5, y: 212.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 288.0, y: 244.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                    position: CGPoint(x: 143.0, y: 106.5),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-orange")),
                                                   BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                    position: CGPoint(x: 349.0, y: 187.0),
                                                    rotation: 0.0,
                                                    radius: 20.0,
                                                    asset: "peg-purple"))]
}
