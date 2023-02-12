//
//  MSKSpriteNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class MSKSpriteNodeTests: XCTestCase {
    var node: MSKSpriteNode?
    let physicsBody = MSKCirclePhysicsBody(circleOfRadius: 1.0, center: .zero, isDynamic: true)
    let image = UIImage(named: "peg-blue")

    override func setUp() {
        super.setUp()

        node = MSKSpriteNode(physicsBody: physicsBody, image: image)
        physicsBody.delegate = node
    }

    func testInit() {
        guard let node = node else {
            return XCTFail("Node is nil")
        }

        XCTAssertNotNil(node.physicsBody)
        XCTAssertEqual(node.position.x, physicsBody.position.x)
        XCTAssertEqual(node.position.y, physicsBody.position.y)
        XCTAssertEqual(node.angle, physicsBody.angle)
        XCTAssertEqual(node.image, image)
    }
}
