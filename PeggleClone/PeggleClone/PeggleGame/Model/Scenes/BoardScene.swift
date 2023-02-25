//
//  BoardScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

enum BucketDirection {
    case right, left
}

class BoardScene: MSKScene {
    var gameState: GameState

    weak var boardSceneDelegate: BoardSceneDelegate?
    var fighter: GameFighter? {
        didSet {
            fighter?.fighterDelegate = self
        }
    }
    var ball: BallNode?
    private var bucket: BucketNode?
    private var bucketDirection: BucketDirection = .right
    private var cannon: CannonNode?
    private var isCannonFired = false
    private let defaultDirectionVectorMultiplier: Double = 10.0
    private let defaultCannonHeight: Double = 50
    private let defaultBallStartingHeight: Double = 50

    init(width: Double, height: Double, gameState: GameState) {
        self.gameState = gameState
        super.init(physicsWorld: MSKPhysicsWorld(width: width, height: height))
    }

    func setupBoard() {
        // Add cannon node
        let cannonPosition = SIMD2<Double>(x: physicsWorld.width / 2, y: defaultCannonHeight)
        let newCannon = CannonNode(center: cannonPosition)
        addNode(newCannon)
        cannon = newCannon

        // Add bucket node
        let newBucket = BucketNode(center: SIMD2<Double>(physicsWorld.width / 2, physicsWorld.height - 50))
        addNode(newBucket)
        bucket = newBucket
        bucket?.bucketDelegate = self

        // Add bucket base & sides
        guard let bucketPb = newBucket.physicsBody as? BucketPhysicsBody else { return }
        physicsWorld.addBody(bucketPb.bucketBase)
        physicsWorld.addBody(bucketPb.bucketLeft)
        physicsWorld.addBody(bucketPb.bucketRight)

        setUpBorders()
    }

    func begin() {
        gameState.startGame()
    }

    func addBoardNode(_ addedNode: BoardObjectNode) {
        super.addNode(addedNode)

        guard let addedNode = addedNode as? PegNode else { return }
        addedNode.delegate = self
    }

    func addBallNode(_ ballNode: BallNode) {
        super.addNode(ballNode)
        ballNode.delegate = self
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
        let angleBetween = PhysicsUtil.findAngleBetween(vectorA: shotVector, vectorB: downVector)

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
        let directionVector = PhysicsUtil.findUnitVector(of: shotVector) * defaultDirectionVectorMultiplier
        let newPos = CGPoint(x: oldPosition.x + directionVector.x, y: oldPosition.y + directionVector.y)
        return newPos
    }

    func isValidLocation(location: CGPoint) -> Bool {
        location.y > defaultBallStartingHeight
    }

    override func update(timeInterval: TimeInterval) {
        super.update(timeInterval: timeInterval)
        updateBucketPos()
        guard let ball = ball else { return }
        if isOutOfBounds(node: ball) {
            // Remove the balls out of the scene.
            handleResetBall()
        }
    }

    func handleResetBall() {
        removeFiredBall()

        // Remove nodes that are hit once ball is out of bounds.
        removeHitPegs()

        // Allow cannon to be fired again
        isCannonFired = false
    }

    private func updateBucketPos() {
        guard let bucketPos = bucket?.position,
              let bucketWidth = bucket?.getWidth(),
              let bucketPb = bucket?.physicsBody as? BucketPhysicsBody else { return }

        if bucketPos.x <= (bucketWidth / 2) {
            bucketDirection = BucketDirection.right
        } else if bucketPos.x >= physicsWorld.width - (bucketWidth / 2) {
            bucketDirection = BucketDirection.left
        }

        var displacement = SIMD2<Double>(2.0, 0.0)
        if bucketDirection == BucketDirection.left {
            displacement = SIMD2<Double>(-2.0, 0.0)
        }

        bucketPb.move(by: displacement)
    }

    private func setUpBorders() {
        let width = physicsWorld.width
        let height = physicsWorld.height
        physicsWorld.addTopBorder(xPos: width / 2, yPos: 0, width: width)
        physicsWorld.addLeftBorder(xPos: 0, yPos: height / 2, height: height)
        physicsWorld.addRightBorder(xPos: width, yPos: height / 2, height: height)
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

    private func removeFiredBall() {
        guard let ball = ball else { return }
        removeNode(ball)
        self.ball = nil
        gameState.ballsLeft -= 1
    }

    private func isOutOfBounds(node: BallNode) -> Bool {
        node.position.y - node.getHeight() > physicsWorld.height
    }
}
