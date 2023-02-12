//
//  BoardSceneTests.swift
//  PeggleCloneTests
//
//  Created by Taufiq Abdul Rahman on 12/2/23.
//

import Foundation
import XCTest

class BoardSceneTests: XCTestCase {
    var boardScene: BoardScene?
    let bsDelegate = MockBoardSceneDelegate()
    
    
    override func setUp() {
        super.setUp()
        boardScene = BoardScene(width: 500, height: 500)
        boardScene?.boardSceneDelegate = bsDelegate
    }

    func testInit() {
        guard let boardScene = boardScene else {
            return XCTFail("Peg Node is nil")
        }
        XCTAssertNotNil(boardScene.boardSceneDelegate)
    }
    
}
