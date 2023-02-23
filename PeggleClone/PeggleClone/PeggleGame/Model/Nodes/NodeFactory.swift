//
//  NodeFactory.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class NodeFactory {
    static func createNode(from boardObject: BoardObject) -> BoardObjectNode? {
        let pos = boardObject.position
        if let peg = boardObject as? Peg {
            switch peg.color {
            case .blue:
                return BluePegNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
            case .orange:
                return OrangePegNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
            case .red:
                return RedPegNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
            case .yellow:
                return YellowPegNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
            }
        } else if boardObject is Block {
            return BlockNode(position: CGPoint(x: pos.x, y: pos.y + defaultHeightBuffer))
        } else {
            // board object doesn't match any existing types
            return nil
        }
    }
}
