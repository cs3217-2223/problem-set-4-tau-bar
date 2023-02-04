//
//  ViewController.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 31/1/23.
//

import UIKit

class GameViewController: UIViewController {
    var boardScene: BoardScene?
    var displayLink: CADisplayLink!
    var count = 0
    @IBOutlet var boardView: BoardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        boardScene = BoardScene(width: boardView.frame.width, height: boardView.frame.height)
        // Set up game loop
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: RunLoop.Mode.default)
        // Set scene for board view
        guard let boardScene = boardScene else { return }
        boardView.setScene(boardScene)
        boardScene.delegate = boardView

        let rectVertices = getVerticesForRect(width: 100, height: 100)
        let staticPhysicsBody = MSKPolygonPhysicsBody(vertices: rectVertices, position: SIMD2<Double>(x: 400, y: 200), isDynamic: false)
        let staticNode = SquareNode(physicsBody: staticPhysicsBody)
        boardScene.addNode(staticNode)
    }
    func begin() {
        boardView.presentScene()
    }
    @objc func step() {
        boardView.refresh(timeInterval: displayLink.targetTimestamp - displayLink.timestamp)
        guard let boardScene = boardScene else { return }
        if count == 25 {
            let newPhysicsBody = MSKCirclePhysicsBody(radius: 20,
                                                       position: SIMD2<Double>(x: 200, y: 400),
                                                       oldPosition: SIMD2<Double>(x: 190, y: 410))
            let newNode = PegNode(physicsBody: newPhysicsBody)
            boardScene.addNode(newNode)
        }
        if count == 50 {
            let vertices = getVerticesForRect(width: 20, height: 20)
            let newPhysicsBody = MSKPolygonPhysicsBody(vertices: vertices,
                                                       position: SIMD2<Double>(x: 200, y: 400),
                                                       oldPosition: SIMD2<Double>(x: 190, y: 410))
            let newNode = SquareNode(physicsBody: newPhysicsBody)
            boardScene.addNode(newNode)
            count = 0
        }
        count += 1
    }
}
