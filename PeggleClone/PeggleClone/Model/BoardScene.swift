//
//  BoardScene.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 2/2/23.
//

import Foundation

class BoardScene: MSKScene, PegNodeDelegate {
    weak var boardView: BoardView?
    var isCannonFired = false
    let defaultDirectionVectorMultiplier: Double = 10.0
    let defaultCannonHeight: Double = 100
    let defaultBallStartingHeight: Double = 250
    let spaceBetweenBalls: Double = 60

    init(width: Double, height: Double) {
        super.init(physicsWorld: MSKPhysicsWorld(width: width, height: height))
    }

    func setupBoard() {
        let cannonPosition = SIMD2<Double>(x: physicsWorld.width / 2, y: defaultCannonHeight)
        addNode(CannonNode(center: cannonPosition))
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
        let originalPos = CGPoint(x: physicsWorld.width / 2, y: defaultBallStartingHeight)

        let leftBallOldPos = CGPoint(x: originalPos.x - spaceBetweenBalls / 2, y: originalPos.y)
        let leftBallNewPos = findNewBallPos(oldPosition: leftBallOldPos, tapLocation: tapLocation)
        let leftBall = BallNode(oldPosition: leftBallOldPos, position: leftBallNewPos)
        print("inside board scene")
        print(leftBallNewPos)
        let rightBallOldPos = CGPoint(x: originalPos.x + spaceBetweenBalls / 2, y: originalPos.y)
        let rightBallNewPos = findNewBallPos(oldPosition: rightBallOldPos, tapLocation: tapLocation)
        let rightBall = BallNode(oldPosition: rightBallOldPos, position: rightBallNewPos)

        addNode(leftBall)
        addNode(rightBall)
    }

    func findNewBallPos(oldPosition: CGPoint, tapLocation: CGPoint) -> CGPoint {
        let shotVector = SIMD2<Double>(x: tapLocation.x - oldPosition.x, y: tapLocation.y - oldPosition.y)
        let directionVector = findUnitVector(of: shotVector) * defaultDirectionVectorMultiplier
        let newPos = CGPoint(x: oldPosition.x + directionVector.x, y: oldPosition.y + directionVector.y)
        return newPos
    }
}
