//
//  BoardScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

class BoardScene: MSKScene, PegNodeDelegate {
    weak var boardView: BoardView?
    private var ball: BallNode?
    private var isCannonFired = false
    private let defaultDirectionVectorMultiplier: Double = 10.0
    private let defaultCannonHeight: Double = 100
    private let defaultBallStartingHeight: Double = 200
    private let spaceBetweenBalls: Double = 60

    init(width: Double, height: Double) {
        super.init(physicsWorld: MSKPhysicsWorld(width: width, height: height))
    }

    func setupBoard() {
        let cannonPosition = SIMD2<Double>(x: physicsWorld.width / 2, y: defaultCannonHeight)
        addNode(CannonNode(center: cannonPosition))
        setUpBorders()
    }

    override func addNode(_ addedNode: MSKSpriteNode) {
        super.addNode(addedNode)

        guard let pegNode = addedNode as? PegNode else { return }

        pegNode.delegate = self
        boardView?.didAddPegNode(addedNode: pegNode)
    }

    func didCollideWithBall(pegNode: PegNode) {
        boardView?.didCollideWithBall(updatedPegNode: pegNode)
    }

    func fireCannon(at tapLocation: CGPoint) {
        if isCannonFired {
            return
        }

        let originalPos = CGPoint(x: physicsWorld.width / 2, y: defaultBallStartingHeight)

        let ballOldPos = CGPoint(x: originalPos.x - spaceBetweenBalls / 2, y: originalPos.y)
        let ballNewPos = findNewBallPos(oldPosition: ballOldPos, tapLocation: tapLocation)
        ball = BallNode(oldPosition: ballOldPos, position: ballNewPos)

        guard let ball = ball else { return }
        addNode(ball)
        isCannonFired = true
    }

    func findNewBallPos(oldPosition: CGPoint, tapLocation: CGPoint) -> CGPoint {
        let shotVector = SIMD2<Double>(x: tapLocation.x - oldPosition.x, y: tapLocation.y - oldPosition.y)
        let directionVector = findUnitVector(of: shotVector) * defaultDirectionVectorMultiplier
        let newPos = CGPoint(x: oldPosition.x + directionVector.x, y: oldPosition.y + directionVector.y)
        return newPos
    }

    func isTapInValidLocation(location: CGPoint) -> Bool {
        location.y > defaultBallStartingHeight
    }

    func setUpBorders() {
        let width = physicsWorld.width
        let height = physicsWorld.height
        physicsWorld.addTopBorder(xPos: width / 2, yPos: 0, width: width)
        physicsWorld.addLeftBorder(xPos: 0, yPos: height / 2, height: height)
        physicsWorld.addRightBorder(xPos: width, yPos: height / 2, height: height)
    }

    override func update(timeInterval: TimeInterval) {
        super.update(timeInterval: timeInterval)
        guard let ball = ball else { return }
        if isOutOfBounds(node: ball) {
            // Remove the balls out of the scene.
            removeFiredBalls()

            // Remove nodes that are hit once ball is out of bounds.
            removeHitPegs()

            // Allow cannon to be fired again
            isCannonFired = false
        }
    }

    func removeHitPegs() {
        var hitPegs: [PegNode] = []
        for node in nodes {
            if let pegNode = node as? PegNode, pegNode.isHit {
                hitPegs.append(pegNode)
            }
        }

        hitPegs.forEach({ hitNode in
            nodes.removeAll(where: { node in node == hitNode })
            physicsWorld.removeBody(hitNode.physicsBody)
            boardView?.fadeOutPegView(removedNode: hitNode)
        })
    }

    func removeFiredBalls() {
        guard let ball = ball else { return }
        removeNode(ball)
        self.ball = nil
    }

    func isOutOfBounds(node: BallNode) -> Bool {
        node.position.y - node.getHeight() > physicsWorld.height
    }
}
