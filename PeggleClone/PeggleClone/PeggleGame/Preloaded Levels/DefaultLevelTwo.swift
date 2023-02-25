//
//  DefaultLevelTwo.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 26/2/23.
//

import Foundation

/// This level was generated using the Level Builder on an iPad mini.
class DefaultLevelTwo: PreloadedLevel {
    static var width: Double = 724
    static var height: Double = 847
    static var balls: Int = 10
    static var gameMode: GameMode = .score
    static var name = "LEVEL 2"
    static var objects = [BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 514.5, y: 479.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 461.0, y: 519.5),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                         position: CGPoint(x: 21.5, y: 824.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-blue")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 187.5, y: 473.5),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                         position: CGPoint(x: 456.0, y: 245.5),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-orange")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                         position: CGPoint(x: 703.5, y: 827.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-blue")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 384.5, y: 545.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                         position: CGPoint(x: 371.5, y: 824.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-green")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.red,
                                                         position: CGPoint(x: 340.5, y: 21.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-red")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                         position: CGPoint(x: 267.5, y: 258.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-orange")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 554.5, y: 441.5),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                         position: CGPoint(x: 20.0, y: 23.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-orange")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 317.5, y: 547.5),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                         position: CGPoint(x: 245.5, y: 515.0),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-purple")),
                                                        BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                         position: CGPoint(x: 704.0, y: 20.5),
                                                         rotation: 0.0,
                                                         radius: 20.0,
                                                         asset: "peg-orange"))]
}
