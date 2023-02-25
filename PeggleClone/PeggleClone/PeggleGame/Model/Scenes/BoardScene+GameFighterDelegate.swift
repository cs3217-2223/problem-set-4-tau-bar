//
//  BoardScene+GameFighterDelegate.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import UIKit

extension BoardScene: GameFighterDelegate {
    func createExplosionAt(location: CGPoint, radius: Double) {
        let explosionNode = addExplosionNode(at: location, radius: radius)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            self.removeNode(explosionNode)
        }

        // Remove nodes which are within 1/2 blast radius
        removeNodes(within: radius / 2, of: location)
        moveNodes(within: radius, awayFrom: location)
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
            if node is BallNode || node is ExplosionNode {
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
                _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    node.physicsBody.isDynamic = false
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
