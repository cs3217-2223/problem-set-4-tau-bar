//
//  PeggleGameConstants.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class PeggleGameConstants {
    static let bluePegPoints = 100
    static let orangePegPoints = 500
    static let defaultPegPoints = 10
    static let defaultExplosionRadius: Double = 100
    static let nonExplodableNodes: [MSKSpriteNode.Type] = [GreenPegNode.self,
                                                           BucketNode.self,
                                                           BallNode.self,
                                                           ExplosionNode.self,
                                                           CannonNode.self]
    static let nonUpsideDownNodes: [MSKSpriteNode.Type] = [BucketNode.self,
                                                           ExplosionNode.self,
                                                           CannonNode.self]
    static let nonMovableByExplosionNodes: [MSKSpriteNode.Type] = [GreenPegNode.self, BallNode.self, BucketNode.self]
    static func getPoints(of pegNode: PegNode) -> Int {
        if pegNode is BluePegNode {
            return bluePegPoints
        } else if pegNode is OrangePegNode {
            return orangePegPoints
        } else {
            return defaultPegPoints
        }
    }

    static func getPoints(of peg: Peg) -> Int {
        switch peg.color {
        case .blue:
            return bluePegPoints
        case .orange:
            return orangePegPoints
        default:
            return defaultPegPoints
        }
    }

    static func createGameState(from board: Board) -> GameState {
        switch board.gameMode {
        case .classic:
            let orangePegs = board.objects.filter({ objectWrapper in
                let object = objectWrapper.object
                if let peg = object as? Peg, peg.color == .orange {
                    return true
                }
                return false
            })
            return ClassicState(initialOrangePegs: orangePegs.count, initialBalls: board.balls)
        case .score:
            var maxPossibleScore: Int = 0
            var allowedTime: Double = 0
            board.objects.forEach({ object in
                if let peg = object.object as? Peg {
                    maxPossibleScore += getPoints(of: peg)
                    allowedTime += 2.0
                }
            })
            let targetScore = Int(floor(0.9 * Double(maxPossibleScore)))
            return ScoreState(scoreToHit: targetScore, timeLimit: allowedTime, ballsLeft: board.balls)
        case .dodge:
            var allowedBalls = board.balls
            if board.balls > 1 {
                allowedBalls = Int(floor(0.9 * Double(allowedBalls)))
            }
            return DodgeState(ballsWithoutHittingLeft: allowedBalls, ballsLeft: board.balls)
        }
    }
}
