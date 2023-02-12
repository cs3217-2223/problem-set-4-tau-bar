//
//  PegNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class PegNodeTests: XCTestCase {
    var pegNode: PegNode?
    let image = UIImage(named: "peg-blue")
    let delegate = MockPegNodeDelegate()

    override func setUp() {
        super.setUp()
        pegNode = PegNode(position: .zero, image: image)
        pegNode?.delegate = delegate
    }

    func testDidCollideWithBall() {
        guard let pegNode = pegNode else {
            return XCTFail("Peg Node is nil")
        }

        XCTAssertFalse(pegNode.isHit)
        XCTAssertFalse(delegate.hasCollidedWithBall)

        pegNode.didCollideWithBall()

        XCTAssertTrue(pegNode.isHit)
        XCTAssertTrue(delegate.hasCollidedWithBall)
    }

}
