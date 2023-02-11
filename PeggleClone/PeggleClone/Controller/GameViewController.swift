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
        
        // Remove reference
        displayLink.remove(from: .current, forMode: RunLoop.Mode.default)
        displayLink = nil
    }

//    @IBAction func didTapExit(_ sender: Any) {
//        displayLink.remove(from: .current, forMode: RunLoop.Mode.default)
//        self.dismiss(animated: true, completion: nil)
//    }

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

    // TODO: Refactor this
    func createPegNode(from peg: Peg) -> PegNode? {
        let pos = peg.getPosition()
        if peg.colour == PegColour.blue {
            return BluePegNode(position: CGPoint(x: pos.xPos, y: pos.yPos + 186))
        } else if peg.colour == PegColour.orange {
            return OrangePegNode(position: CGPoint(x: pos.xPos, y: pos.yPos + 186))
        } else {
            return nil
        }
    }

    func setUpBoardScene() {
        boardScene = BoardScene(width: boardView.frame.width, height: boardView.frame.height)

        boardScene?.setupBoard()

        for peg in board?.pegs ?? [] {
            guard let pegNode = createPegNode(from: peg) else { continue }
            boardScene?.addPegNode(pegNode)
        }
    }

    func setUpGameLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: RunLoop.Mode.default)
    }
}
