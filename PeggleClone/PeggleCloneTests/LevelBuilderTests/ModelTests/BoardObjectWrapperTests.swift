//
//  BoardObjectWrapperTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 16/2/23.
//

import Foundation
import XCTest

class BoardObjectWrapperTests: XCTestCase {

    func testHash() {
        guard let object1 = Peg(colour: .orange, position: .zero),
              let object2 = Peg(colour: .orange, position: .zero)
        else {
            return
        }

        let wrapper1 = BoardObjectWrapper(object: object1)
        let wrapper2 = BoardObjectWrapper(object: object2)
        let wrapper3 = BoardObjectWrapper(object: object1)

        XCTAssertNotEqual(wrapper1.hashValue, wrapper2.hashValue)
        XCTAssertEqual(wrapper1.hashValue, wrapper3.hashValue)
    }

    func testEquality() {
        guard let object1 = Peg(colour: .orange, position: .zero),
              let object2 = Peg(colour: .orange, position: .zero)
        else {
            return
        }

        let wrapper1 = BoardObjectWrapper(object: object1)
        let wrapper2 = BoardObjectWrapper(object: object2)
        let wrapper3 = BoardObjectWrapper(object: object1)

        XCTAssertTrue(wrapper1 == wrapper3)
        XCTAssertFalse(wrapper2 == wrapper1)
        XCTAssertFalse(wrapper2 == wrapper3)
    }
}
