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

        let newNode = BluePegNode(position: CGPoint(x: 200, y: 400))
        boardScene.addNode(newNode)
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
//        guard let boardScene = boardScene else { return }
//        if count == 25 {
//            let newNode = OrangePegNode(position: CGPoint(x: 200, y: 400))
//            boardScene.addNode(newNode)
//        }
//        if count == 60 {
//            let newNode = BluePegNode(position: CGPoint(x: 200, y: 400))
//            boardScene.addNode(newNode)
//        }
//        if count == 300 {
//            let newNode = BallNode(position: CGPoint(x: 200, y: 400))
//            boardScene.addNode(newNode)
//            count = 0
//        }
//        count += 1
    }
}
