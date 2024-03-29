//
//  DefaultLevels.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 25/2/23.
//

import Foundation

class DefaultLevelOne: PreloadedLevel {
    static var width: Double = 500
    static var height: Double = 720
    static var balls: Int = 7
    static var gameMode: GameMode = .classic
    static var name = "LEVEL 1"
    static var objects = [BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 349.0, y: 342.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 173.0, y: 609.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 202.5, y: 567.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 21.5, y: 696.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 459.5, y: 22.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 158.0, y: 214.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 128.0, y: 276.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 103.5, y: 195.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 210.0, y: 388.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 312.0, y: 404.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 255.0, y: 645.5),
                                                            rotation: -1.1555283069610596,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 79.5, y: 602.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 104.0, y: 565.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 139.0, y: 451.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 318.0, y: 255.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 160.5, y: 376.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 47.5, y: 641.0),
                                                            rotation: -1.6249616146087646,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 207.5, y: 282.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 269.5, y: 409.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 96.0, y: 644.0),
                                                            rotation: 1.4805206060409546,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 402.0, y: 418.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 200.5, y: 646.5),
                                                            rotation: 1.7332924604415894,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 298.0, y: 643.0),
                                                            rotation: 1.516631007194519,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 333.5, y: 686.5),
                                                            rotation: 1.29996919631958,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 127.5, y: 138.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 212.0, y: 439.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 274.5, y: 687.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 54.5, y: 297.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 263.5, y: 137.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.red,
                                                            position: CGPoint(x: 262.5, y: 523.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-red")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 243.5, y: 569.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 208.5, y: 54.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 295.0, y: 218.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 281.0, y: 606.5),
                                                            rotation: -0.8666461110115051,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 377.5, y: 688.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 254.0, y: 85.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 332.5, y: 303.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 29.0, y: 343.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 177.5, y: 689.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 271.0, y: 342.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 23.5, y: 22.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 309.0, y: 491.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 163.5, y: 82.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 298.5, y: 570.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 209.0, y: 335.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 115.5, y: 328.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 177.0, y: 472.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 346.5, y: 465.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.red,
                                                            position: CGPoint(x: 201.5, y: 522.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-red")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 124.5, y: 604.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 73.0, y: 395.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 375.0, y: 382.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 351.5, y: 647.0),
                                                            rotation: 0.8666461706161499,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 159.5, y: 565.5),
                                                            rotation: -1.0833077430725098,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 206.0, y: 127.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 123.5, y: 692.5),
                                                            rotation: 1.0110872983932495,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 72.0, y: 695.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.red,
                                                            position: CGPoint(x: 144.5, y: 516.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-red")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 78.5, y: 248.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 226.5, y: 609.0),
                                                            rotation: -0.9388666749000549,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 148.0, y: 649.5),
                                                            rotation: -1.01108717918396,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.purple,
                                                            position: CGPoint(x: 280.0, y: 175.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-purple")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 237.5, y: 477.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.green,
                                                            position: CGPoint(x: 229.0, y: 686.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-green")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 264.5, y: 283.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.blue,
                                                            position: CGPoint(x: 327.0, y: 610.5),
                                                            rotation: 1.1555284261703491,
                                                            radius: 20.0,
                                                            asset: "peg-blue")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 209.0, y: 232.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 209.5, y: 176.0),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange")),
                                                           BoardObjectWrapper(object: Peg(color: PegColor.orange,
                                                            position: CGPoint(x: 110.5, y: 421.5),
                                                            rotation: 0.0,
                                                            radius: 20.0,
                                                            asset: "peg-orange"))]
}
