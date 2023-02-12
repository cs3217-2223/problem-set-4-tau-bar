//
//  CannonNodeTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class CannonNodeTests: XCTestCase {
    var cannonNode: CannonNode?
    let image = UIImage(named: "cannon")

    override func setUp() {
        super.setUp()
        cannonNode = CannonNode(center: .zero)
    }

    func testInit() {
        guard let cannonNode = cannonNode else {
            return XCTFail("Cannon Node is nil")
        }
        XCTAssertEqual(cannonNode.image, image)
    }
}
