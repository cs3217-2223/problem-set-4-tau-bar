//
//  BluePegNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class BluePegNodeTests: XCTestCase {
    var pegNode: BluePegNode?
    let image = UIImage(named: "peg-blue")

    override func setUp() {
        super.setUp()
        pegNode = BluePegNode(position: .zero)
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

        XCTAssertEqual(pegNode.image, image)

        pegNode.didCollideWithBall()

        XCTAssertEqual(pegNode.image, UIImage(named: "peg-blue-glow"))
    }

}
