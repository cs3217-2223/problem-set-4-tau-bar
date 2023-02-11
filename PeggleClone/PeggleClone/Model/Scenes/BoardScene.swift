//
//  BoardScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

class BoardScene: MSKScene, PegNodeDelegate, BallNodeDelegate {
    weak var boardSceneDelegate: BoardSceneDelegate?
    private var ball: BallNode?
    private var cannon: CannonNode?
    private var isCannonFired = false
    private let defaultDirectionVectorMultiplier: Double = 10.0
    private let defaultCannonHeight: Double = 50
    private let defaultBallStartingHeight: Double = 50
    private let spaceBetweenBalls: Double = 60

    init(width: Double, height: Double) {
        super.init(physicsWorld: MSKPhysicsWorld(width: width, height: height))
    }

    func setupBoard() {
        let cannonPosition = SIMD2<Double>(x: physicsWorld.width / 2, y: defaultCannonHeight)
        let newCannon = CannonNode(center: cannonPosition)
        addNode(newCannon)
        cannon = newCannon
        setUpBorders()
    }

    func addPegNode(_ addedNode: PegNode) {
        super.addNode(addedNode)
        addedNode.delegate = self
    }

    func addBallNode(_ ballNode: BallNode) {
        super.addNode(ballNode)
        ballNode.delegate = self
    }

    func didCollideWithBall(pegNode: PegNode) {
        boardSceneDelegate?.didCollideWithBall(updatedPegNode: pegNode)
    }

    func fireCannon(at tapLocation: CGPoint) {
        if isCannonFired {
            return
        }

        let originalPos = CGPoint(x: physicsWorld.width / 2, y: defaultBallStartingHeight)

        let ballOldPos = CGPoint(x: originalPos.x, y: originalPos.y)
        let ballNewPos = findNewBallPos(oldPosition: ballOldPos, tapLocation: tapLocation)
        ball = BallNode(oldPosition: ballOldPos, position: ballNewPos)

        // Rotate cannon to aim at target location
        let shotVector = SIMD2<Double>(x: tapLocation.x - ballOldPos.x, y: tapLocation.y - ballOldPos.y)
        let downVector = SIMD2<Double>(x: 0, y: 1.0)
        let angleBetween = findAngleBetween(vectorA: shotVector, vectorB: downVector)

        guard let cannonPosX = cannon?.position.x else { return }
        if tapLocation.x > cannonPosX {
            cannon?.updateAngle(newAngle: -angleBetween)
        } else {
            cannon?.updateAngle(newAngle: angleBetween)
        }

        guard let ball = ball else { return }
        addBallNode(ball)
        isCannonFired = true
    }

    private func findNewBallPos(oldPosition: CGPoint, tapLocation: CGPoint) -> CGPoint {
        let shotVector = SIMD2<Double>(x: tapLocation.x - oldPosition.x, y: tapLocation.y - oldPosition.y)
        let directionVector = findUnitVector(of: shotVector) * defaultDirectionVectorMultiplier
        let newPos = CGPoint(x: oldPosition.x + directionVector.x, y: oldPosition.y + directionVector.y)
        return newPos
    }

    func isValidLocation(location: CGPoint) -> Bool {
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
            removeFiredBall()

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
            nodes.removeAll(where: { $0 == hitNode })
            physicsWorld.removeBody(hitNode.physicsBody)
            boardSceneDelegate?.didRemovePegNode(removedNode: hitNode)
        })
    }

    func removeFiredBall() {
        guard let ball = ball else { return }
        removeNode(ball)
        self.ball = nil
    }

    func isOutOfBounds(node: BallNode) -> Bool {
        node.position.y - node.getHeight() > physicsWorld.height
    }

    func handleBallStuck() {
        removeHitPegs()
    }
}
