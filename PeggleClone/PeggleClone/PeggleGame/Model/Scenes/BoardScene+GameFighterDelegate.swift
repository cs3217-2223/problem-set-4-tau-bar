//
//  BoardScene+GameFighterDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import UIKit

extension BoardScene: GameFighterDelegate {
    static let defaultExplosionRadius: Double = 250
    func createExplosionAt(pegNode: PegNode) {
        // remove exploding node
        removeNode(pegNode)
        
        let radius = BoardScene.defaultExplosionRadius
        let explosionNode = addExplosionNode(at: pegNode.position, radius: radius)

        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [unowned self] _ in
            removeNode(explosionNode)
        }

        // Remove nodes which are within 1/2 blast radius
        removeNodes(within: radius / 2, of: pegNode.position)
        moveNodes(within: radius, awayFrom: pegNode.position)
    }

    func setSpookyBall() {
        ball?.isSpooky = true
    }

    private func addExplosionNode(at location: CGPoint, radius: Double) -> ExplosionNode {
        let explosionCenter = SIMD2<Double>(location.x, location.y)
        let explosionPhysicsBody = MSKCirclePhysicsBody(circleOfRadius: radius,
                                                        center: explosionCenter,
                                                        isDynamic: false,
                                                        rotation: 0)
        let explosionNode = ExplosionNode(physicsBody: explosionPhysicsBody, image: nil)
        boardSceneDelegate?.didAddExplosion(at: location, duration: 0.5, radius: radius)
        addNode(explosionNode)

        return explosionNode
    }

    private func removeNodes(within radius: Double, of location: CGPoint) {
        for node in nodes {
            if node is BallNode || node is ExplosionNode || node is GreenPegNode {
                continue
            }

            if isWithin(position: node.position, isWithin: radius, of: location) {
                removeNode(node)
            }
        }
    }

    private func moveNodes(within radius: Double, awayFrom location: CGPoint) {
        for node in nodes {
            if isWithin(position: node.position, isWithin: radius, of: location), !(node is BallNode) {
                node.physicsBody.isDynamic = true
                _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [unowned self] _ in
                    node.physicsBody.isDynamic = false
                    if let node = node as? GreenPegNode {
                        createExplosionAt(pegNode: node)
                    }
                }
            }
        }
    }

    private func isWithin(position: CGPoint, isWithin radius: Double, of location: CGPoint) -> Bool {
        let dx = Double(position.x - location.x)
        let dy = Double(position.y - location.y)
        let distance = sqrt(dx * dx + dy * dy)
        return distance <= radius
    }
}
