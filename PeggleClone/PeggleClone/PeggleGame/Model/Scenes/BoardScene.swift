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
    var gameState: GameState {
        didSet {
            gameState.delegate = self
        }
    }

    var boardSceneDelegates: [BoardSceneDelegate] = []
    var fighter: GameFighter? {
        didSet {
            fighter?.fighterDelegate = self
        }
    }
    var ball: BallNode?
    var isCannonFired = false
    var bucket: BucketNode?
    private var bucketDirection: BucketDirection = .right
    private var cannon: CannonNode?
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

    /// Adds a `BoardObjectNode` to the scene.
    func addBoardNode(_ addedNode: BoardObjectNode) {
        super.addNode(addedNode)

        guard let addedNode = addedNode as? PegNode else { return }
        addedNode.delegate = self
    }

    /// Adds a `BallNode` to the scene.
    func addBallNode(_ ballNode: BallNode) {
        super.addNode(ballNode)
        ballNode.delegate = self
    }

    /// Fires the cannon at the `tapLocation` by adding a new `BallNode` & setting `isCannonFired` to true.
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
        boardSceneDelegates.forEach({ $0.didFireCannon() })
    }

    /// Checks whether a tap location is valid - i.e. below the cannon's height
    func isValidLocation(location tapLocation: CGPoint) -> Bool {
        tapLocation.y > defaultCannonHeight
    }

    /// Updates the state of the scene over the `timeInterval`.
    override func update(timeInterval: TimeInterval) {
        super.update(timeInterval: timeInterval)
        updateBucketPos()

        for node in nodes {
            guard let ballNode = node as? BallNode else { continue }
            if isOutOfBounds(node: ballNode) {
                handleResetBall(ballNode: ballNode)
            }
        }

    }

    func handleResetBall(ballNode: BallNode) {
        if ballNode.isSpooky {
            resetSpookyBall(ballNode: ballNode)
        } else {
            removeNode(ballNode)

            // if it was the originally fired ball
            if ballNode == ball {
                self.ball = nil
                gameState.ballsLeft -= 1
                // Remove nodes that are hit once ball is out of bounds.
                removeHitPegs()

                isCannonFired = false
            }
        }
    }

    /// Resets the spooky ball by setting `isSpooky` to false & putting it at y = 0.
    func resetSpookyBall(ballNode: BallNode) {
        var currentPos = ballNode.position
        if currentPos.x > physicsWorld.width {
            currentPos.x = physicsWorld.width - ballNode.getWidth()
        } else if currentPos.x < 0 {
            currentPos.x = ballNode.getWidth()
        }

        // Set the y position to be height / 2 to ensure doesn't collide with top border of world
        ballNode.physicsBody.move(to: SIMD2<Double>(currentPos.x, ballNode.getHeight() / 2))
        ballNode.isSpooky = false
    }

    /// Calculates the new position of the ball using `tapLocation` and ball's `oldPosition`.
    private func findNewBallPos(oldPosition: CGPoint, tapLocation: CGPoint) -> CGPoint {
        let shotVector = SIMD2<Double>(x: tapLocation.x - oldPosition.x, y: tapLocation.y - oldPosition.y)
        let directionVector = PhysicsUtil.findUnitVector(of: shotVector) * defaultDirectionVectorMultiplier
        let newPos = CGPoint(x: oldPosition.x + directionVector.x, y: oldPosition.y + directionVector.y)
        return newPos
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
            boardSceneDelegates.forEach({ $0.didRemoveBoardNode(removedNode: hitNode) })
        })
    }

    func addDelegate(delegate: BoardSceneDelegate) {
        boardSceneDelegates.append(delegate)
    }

    private func isOutOfBounds(node: BallNode) -> Bool {
        node.position.y + node.getHeight() < 0 ||
        node.position.y - node.getHeight() > physicsWorld.height ||
        node.position.x - node.getWidth() > physicsWorld.width ||
        node.position.x + node.getWidth() < 0
    }
}
