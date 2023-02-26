//
//  MSKSceneTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class MSKSceneTests: XCTestCase {
    var scene: MSKScene?
    let physicsWorld = MockPhysicsWorld()
    let delegate = MockMSKSceneDelegate()
    let sNode = MSKSpriteNode(physicsBody: MSKCirclePhysicsBody(circleOfRadius: 1.0,
                                                               center: .zero,
                                                               isDynamic: true, rotation: 0),
                             image: UIImage(named: "peg-blue"))

    let defaultTimeInterval: Double = 0.1

    override func setUp() {
        super.setUp()
        scene = MSKScene(physicsWorld: physicsWorld)
        scene?.delegate = delegate
    }

    func testInit() {
        guard let scene = scene else {
            return XCTFail("Scene is nil")
        }

        XCTAssertNotNil(scene.physicsWorld)
        XCTAssertEqual(scene.nodes, [])
        XCTAssertNotNil(scene.delegate)
    }

    func testAddNode_addsNode() {
        XCTAssertEqual(scene?.nodes.count, 0)
        XCTAssertEqual(scene?.physicsWorld.bodiesCount, 0)
        XCTAssertFalse(delegate.isNodeAdded)

        scene?.addNode(sNode)

        XCTAssertEqual(scene?.nodes.count, 1)
        XCTAssertEqual(scene?.physicsWorld.bodiesCount, 1)
        XCTAssertTrue(delegate.isNodeAdded)
    }

    func testRemoveNode_ifNodeExists_removesNode() {
        scene?.addNode(sNode)
        XCTAssertEqual(scene?.nodes.count, 1)
        XCTAssertEqual(scene?.physicsWorld.bodiesCount, 1)

        scene?.removeNode(sNode)
        XCTAssertEqual(scene?.nodes.count, 0)
        XCTAssertEqual(scene?.physicsWorld.bodiesCount, 0)
        XCTAssertTrue(delegate.isNodeRemoved)

    }

    func testUpdate() {
        scene?.addNode(sNode)
        XCTAssertEqual(scene?.nodes.count, 1)
        XCTAssertEqual(scene?.physicsWorld.bodiesCount, 1)
        XCTAssertFalse(delegate.isNodeRotated)
        XCTAssertFalse(delegate.isNodeUpdated)

        scene?.update(timeInterval: defaultTimeInterval)

        guard let physicsWorld = scene?.physicsWorld as? MockPhysicsWorld else {
            return XCTFail("Physics world is not mock")
        }

        XCTAssertTrue(physicsWorld.isPhysicsSimulated)
        XCTAssertTrue(delegate.isNodeRotated)
        XCTAssertTrue(delegate.isNodeUpdated)
    }

}
