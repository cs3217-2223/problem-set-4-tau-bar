//
//  BoardScene+GameFighterDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import UIKit

extension BoardScene: GameFighterDelegate {
    func createExplosionAt(pegNode: PegNode) {
        guard let pegNode = pegNode as? GreenPegNode else { return }

        if pegNode.isExploding {
            return
        }

        pegNode.isExploding = true
        pegNode.image = UIImage(named: "peg-purple-glow")
        delegate?.didUpdateNodeImage(pegNode)
        // remove exploding node
        removeNode(pegNode)

        let radius = PeggleGameConstants.defaultExplosionRadius

        // add an explosion node for a short time to
        // simulate collision between pegs and explosion "body"
        let explosionNode = addExplosionNode(at: pegNode.position, radius: radius)

        // remove nodes which are within 1/2 blast radius
        removeNodesByExplosion(within: radius / 2, of: pegNode.position)

        // move nodes which are within blast radius
        moveNodesByExplosion(within: radius, awayFrom: pegNode.position)

        // trigger other green nodes within blast radius
        triggerOtherGreenWithinExplosion(within: radius, awayFrom: pegNode.position)

        // remove explosion node after time interval
        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [unowned self] _ in
            removeNode(explosionNode)
        }
    }

    func setSpookyBall(ballNode: BallNode) {
        ballNode.isSpooky = true
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

    private func removeNodesByExplosion(within radius: Double, of location: CGPoint) {
        for node in nodes {
            // does not get removed by explosion
            if PeggleGameConstants.nonExplodableNodes.contains(where: { $0 == type(of: node) }) {
                continue
            }

            if isWithin(position: node.position, isWithin: radius, of: location) {
                removeNode(node)
            }
        }
    }

    private func moveNodesByExplosion(within radius: Double, awayFrom location: CGPoint) {
        for node in nodes {
            // does not get moved by explosion
            if PeggleGameConstants.nonExplodableNodes.contains(where: { $0 == type(of: node) }) {
                continue
            }

            if isWithin(position: node.position, isWithin: radius, of: location) {
                node.physicsBody.isDynamic = true
                _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    node.physicsBody.isDynamic = false
                }
            }
        }
    }

    private func triggerOtherGreenWithinExplosion(within radius: Double, awayFrom location: CGPoint) {
        for node in nodes {
            if let node = node as? GreenPegNode, isWithin(position: node.position, isWithin: radius, of: location) {
                // mark node for explosion
                node.image = UIImage(named: "peg-green-glow")
                delegate?.didUpdateNodeImage(node)

                // after time interval, create explosion
                _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [unowned self] _ in
                    createExplosionAt(pegNode: node)
                }

            }
        }
    }

    private func isWithin(position: CGPoint, isWithin radius: Double, of location: CGPoint) -> Bool {
        let diffX = Double(position.x - location.x)
        let diffY = Double(position.y - location.y)
        let distance = sqrt(diffX * diffX + diffY * diffY)
        return distance <= radius
    }
}
