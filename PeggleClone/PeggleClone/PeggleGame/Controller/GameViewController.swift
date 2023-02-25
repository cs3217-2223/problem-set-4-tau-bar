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
    @IBOutlet var ballsLeftLabel: UILabel!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    var musicPlayer: MusicPlayer?
    var gameFighter: GameFighter? {
        didSet {
            boardScene?.fighter = gameFighter
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        // first time entering
        musicPlayer = MusicPlayer()
        musicPlayer?.startGameMusic()

        print(board?.gameMode)
        print(board?.width)
        print(board?.height)

        board?.objects.forEach({ obj in
            let object = obj.object
            if let peg = object as? Peg {
                print(getPegString(peg: peg))
            } else if let block = object as? Block {
                print(getBlockString(block: block))
            }
        })

        performSegue(withIdentifier: "goToChooseMaster", sender: self)
    }

    func getPegString(peg: Peg) -> String {
        var str = ""
        str += "BoardObjectWrapper(object: Peg(color: "
        str += "PegColor." + peg.color.rawValue
        str += ", \n position: CGPoint(x: "
        str += String(Double(peg.position.x)) + ", y: "
        str += String(Double(peg.position.y)) + ")"
        str += ", \n rotation: " + String(peg.rotation)
        str += ", \n radius: " + String(peg.radius)
        str += ", \n asset: \"" + String(peg.asset) + "\")),"
        return str
    }

    func getBlockString(block: Block) -> String {
        var str = ""
        str += "BoardObjectWrapper(object: Block(position: CGPoint(x: "
        str += String(Double(block.position.x)) + ", y: "
        str += String(Double(block.position.y)) + ")"
        str += ", \n rotation: " + String(block.rotation)
        str += ", \n height: " + String(block.height)
        str += ", \n width: " + String(block.width) + ")),"
//        Block(position: <#T##CGPoint#>, rotation: <#T##Double#>, height: <#T##Double#>, width: <#T##Double#>)
        return str
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpBoardScene()
        updateGameDetails()

        // Set scene for board view
        guard let boardScene = boardScene else { return }
        boardView.setScene(boardScene)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        musicPlayer?.stopGameMusic()

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
        updateGameDetails()

        guard let isGameWon = boardScene?.gameState.isGameWon(),
        let isGameLost = boardScene?.gameState.isGameLost() else { return }
        if isGameWon {
            alertUserWon()
            displayLink.isPaused = true
        }

        if isGameLost {
            alertUserLost()
            displayLink.isPaused = true
        }
    }

    func updateGameDetails() {
        guard let gameState = boardScene?.gameState else { return }
        firstLabel.text = gameState.firstLabel
        secondLabel.text = gameState.secondLabel
        thirdLabel.text = gameState.thirdLabel
        ballsLeftLabel.text = String(gameState.ballsLeft)
    }

    func setUpBoardScene() {
        guard let board = board else { return }
        let gameState = PeggleGameConstants.createGameState(from: board)
        boardScene = BoardScene(width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height,
                                gameState: gameState)

        boardScene?.setupBoard()

        for objectWrapper in board.objects {
            let object = objectWrapper.object
            guard let objectNode = NodeFactory.createNode(from: object) else { return }
            boardScene?.addBoardNode(objectNode)
        }
    }

    func startGameLoop() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .current, forMode: RunLoop.Mode.default)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseMaster" {
            guard let vc = segue.destination as? ChooseMasterViewController else { return }
            // do any additional setup
            vc.delegate = self
        }
    }

    private func alertUserWon() {
        let alert = UIAlertController(title: "YOU WIN", message: "Congratulations!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in self.dismiss(animated: true) }))
        self.present(alert, animated: true, completion: nil)
    }

    private func alertUserLost() {
        let alert = UIAlertController(title: "GAME OVER", message: "You lose!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default,
                                      handler: { _ in self.dismiss(animated: true) }))
        self.present(alert, animated: true, completion: nil)
    }
}
