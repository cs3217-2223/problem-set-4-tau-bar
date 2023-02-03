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
    @IBOutlet weak var boardView: BoardView!
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
        
        let staticPhysicsBody = MSKPhysicsBody(radius: 50, position: SIMD2<Double>(x: 400, y: 200),
                                               oldPosition: SIMD2<Double>(x: 400, y: 200), isDynamic: false)
        let staticNode = PegNode(physicsBody: staticPhysicsBody)
        boardScene.addNode(staticNode)
    }
    func begin() {
        boardView.presentScene()
    }
    @objc func step() {
        boardView.refresh(dt: displayLink.targetTimestamp - displayLink.timestamp)
        guard let boardScene = boardScene else { return }
        if count == 100 {
            let newPhysicsBody = MSKPhysicsBody(position: SIMD2<Double>(x: 400, y: 50),
                                                oldPosition: SIMD2<Double>(x: 400, y: 50))
            let newNode = PegNode(physicsBody: newPhysicsBody)
            boardScene.addNode(newNode)
            count = 0
        }
        count += 1
    }
}
