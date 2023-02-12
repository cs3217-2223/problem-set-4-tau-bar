//
//  MSKViewTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class MSKViewTests: XCTestCase {
    let scene = MockMSKScene()
    var view: MSKView?
    let physicsBody = MSKCirclePhysicsBody(circleOfRadius: 1.0,
                                           center: .zero,
                                           isDynamic: true)
    let image = UIImage(named: "peg-blue")
    let defaultTimeInterval: Double = 0.1

    override func setUp() {
        super.setUp()
        view = MSKView()
        view?.scene = scene
        scene.delegate = view
    }

    func testInit() {
        XCTAssertNotNil(scene)
        XCTAssertEqual(view?.nodeToView, [:])
    }

    func testCreateImageView_shouldReturnCorrectView() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)

        let createdView = view?.createImageView(from: node)

        XCTAssertEqual(createdView?.image, image)
        guard let viewFrame = createdView?.frame else {
            return XCTFail("Frame is nil")
        }
        XCTAssertEqual(Double(viewFrame.width), node.getWidth())
        XCTAssertEqual(Double(viewFrame.height), node.getHeight())
    }

    func testAddSubview_shouldAddSubview() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)

        view?.addSubview(from: node)

        XCTAssertNotNil(view?.nodeToView[node])
        guard let createdView = view?.nodeToView[node] else {
            return XCTFail("View is nil")
        }
        XCTAssertEqual(createdView.image, image)
        XCTAssertEqual(Double(createdView.frame.width), node.getWidth())
        XCTAssertEqual(Double(createdView.frame.height), node.getHeight())
    }

    func testDidRemoveNode_shouldRemoveView() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)
        view?.addSubview(from: node)

        XCTAssertNotNil(view?.nodeToView[node])
        guard let createdView = view?.nodeToView[node] else {
            return XCTFail("Created View is nil")
        }

        view?.didRemoveNode(node)
        XCTAssertNil(view?.nodeToView[node])
        guard let isCreatedViewStillSubview = view?.subviews.contains(where: { $0 == createdView }) else {
            return XCTFail("Result is nil")
        }

        XCTAssertFalse(isCreatedViewStillSubview)
    }

    func testDidAddNode_shouldAddView() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)

        view?.didAddNode(node)

        XCTAssertNotNil(view?.nodeToView[node])
    }

    func testDidUpdateNode_shouldUpdateView() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)
        let originalNodePosition = node.position

        XCTAssertEqual(node.position, .zero)

        view?.addSubview(from: node)

        XCTAssertNotNil(view?.nodeToView[node])
        guard let createdView = view?.nodeToView[node] else {
            return XCTFail("Created View is nil")
        }
        XCTAssertEqual(createdView.center, originalNodePosition)

        let newPosition = CGPoint(x: 1.0, y: 1.0)
        node.position = newPosition
        view?.didUpdateNode(node)

        XCTAssertEqual(createdView.center, newPosition)
    }

    func testDidRotateNode_shouldRotateView() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)
        let originalNodeAngle = node.angle

        view?.didAddNode(node)

        XCTAssertNotNil(view?.nodeToView[node])
        guard let createdView = view?.nodeToView[node] else {
            return XCTFail("Created View is nil")
        }
        XCTAssertEqual(createdView.transform, CGAffineTransformMakeRotation(originalNodeAngle))

        let newAngle = originalNodeAngle + 0.2
        node.angle = newAngle
        view?.didRotateNode(node)

        XCTAssertEqual(createdView.transform, CGAffineTransformMakeRotation(newAngle))
    }

    func testRefresh_shouldUpdateScene() {
        XCTAssertFalse(scene.isUpdated)

        view?.refresh(timeInterval: defaultTimeInterval)

        XCTAssertTrue(scene.isUpdated)
    }

    func testPresentScene_shouldAddSubviews() {
        let node = MSKSpriteNode(physicsBody: physicsBody, image: image)
        scene.addNode(node)

        view?.presentScene()

        XCTAssertNotNil(view?.nodeToView[node])
    }
}
