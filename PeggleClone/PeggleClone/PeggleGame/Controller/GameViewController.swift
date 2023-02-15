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
    var board: Board?
    @IBOutlet var boardView: BoardView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpBoardScene()

        // Set scene for board view
        guard let boardScene = boardScene else { return }
        boardView.setScene(boardScene)

        // Set up game loop
        setUpGameLoop()

        begin()
    }

    func begin() {
        boardView.presentScene()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Remove reference to displayLink to prevent memory leak
        displayLink.remove(from: .current, forMode: RunLoop.Mode.default)
        displayLink = nil
    }

    @IBAction func didTapBoardView(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: boardView)
        guard let isTapLocationValid = boardScene?.isValidLocation(location: tapLocation) else { return }
        if isTapLocationValid {
            boardScene?.fireCannon(at: tapLocation)
        }
    }

    @objc func step() {
        boardView.refresh(timeInterval: displayLink.targetTimestamp - displayLink.timestamp)
    }

    func createPegNode(from peg: Peg) -> PegNode? {
        let pos = peg.position
        if peg.colour == PegColor.blue {
            return BluePegNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
        } else if peg.colour == PegColor.orange {
            return OrangePegNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
        } else {
            return nil
        }
    }

    func setUpBoardScene() {
        boardScene = BoardScene(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        boardScene?.setupBoard()

        for objectWrapper in board?.objects ?? [] {
            guard let peg = objectWrapper.object as? Peg,
                  let pegNode = createPegNode(from: peg) else { continue }
            boardScene?.addPegNode(pegNode)
        }
    }

    func setUpGameLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: RunLoop.Mode.default)
    }
}
