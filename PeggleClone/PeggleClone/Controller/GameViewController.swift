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

        // Set scene for board view
        guard let boardScene = boardScene else { return }
        boardView.setScene(boardScene)

        // Set up game loop
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: RunLoop.Mode.default)

        for one in 0..<5 {
            for two in 0..<5 {
                let blueNode = BluePegNode(position: CGPoint(x: 200 + 100 * one, y: 300 + 60 * two))
                boardScene.addNode(blueNode)
                let orangeNode = OrangePegNode(position: CGPoint(x: 200 + 100 * one, y: 700 + 60 * two))
                boardScene.addNode(orangeNode)
//                let squareNode = SquareNode(physicsBody: MSKPolygonPhysicsBody(vertices: getVerticesForRect(width: 20, height: 20),
//                                                                               position: SIMD2<Double>(x: Double(200 + 100 * one), y: Double(700 + 60 * two)),
//                                                                               affectedByGravity: false))
//                boardScene.addNode(squareNode)
            }
        }

    }

    func begin() {
        boardView.presentScene()
    }

    @IBAction func didTapBoardView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: boardView)
        guard let isTapLocationValid = boardScene?.isTapInValidLocation(location: tapLocation) else { return }
        if isTapLocationValid {
            boardScene?.fireCannon(at: tapLocation)
        }
    }

    @objc func step() {
        boardView.refresh(timeInterval: displayLink.targetTimestamp - displayLink.timestamp)
    }
}
