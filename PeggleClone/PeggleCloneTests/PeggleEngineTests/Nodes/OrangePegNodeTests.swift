//
//  OrangePegNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class OrangePegNodeTests: XCTestCase {
    var pegNode: OrangePegNode?
    let image = UIImage(named: "peg-orange")

    override func setUp() {
        super.setUp()
        pegNode = OrangePegNode(position: .zero, radius: 20, rotation: 0)
    }

    func testInit() {
        guard let pegNode = pegNode else {
            return XCTFail("Peg Node is nil")
        }
        XCTAssertEqual(pegNode.image, image)
    }

    func testDidCollideWithBall() {
        guard let pegNode = pegNode else {
            return XCTFail("Peg Node is nil")
        }
        let ballBody = BallPhysicsBody(circleOfRadius: 20, center: .zero, isDynamic: false, rotation: 0)

        XCTAssertEqual(pegNode.image, image)

        pegNode.didCollideWithBall(ballBody: ballBody)

        XCTAssertEqual(pegNode.image, UIImage(named: "peg-orange-glow"))
    }

}
