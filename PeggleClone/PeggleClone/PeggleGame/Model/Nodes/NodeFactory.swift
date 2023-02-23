//
//  NodeFactory.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 23/2/23.
//

import Foundation

class NodeFactory {
    static func createNode(from boardObject: BoardObject) -> BoardObjectNode? {
        let pos = CGPoint(x: boardObject.position.x, y: boardObject.position.y + PeggleCloneConstants.defaultBufferTop)
        let rotation = boardObject.rotation
        if let peg = boardObject as? Peg {
            switch peg.color {
            case .blue:
                return BluePegNode(position: pos, radius: peg.radius, rotation: rotation)
            case .orange:
                return OrangePegNode(position: pos, radius: peg.radius, rotation: rotation)
            case .red:
                return RedPegNode(position: pos, radius: peg.radius, rotation: rotation)
            case .purple:
                return YellowPegNode(position: pos, radius: peg.radius, rotation: rotation)
            }
        } else if boardObject is Block {
            return BlockNode(position: pos,
                             width: boardObject.width,
                             height: boardObject.height,
                             rotation: boardObject.rotation)
        } else {
            // board object doesn't match any existing types
            return nil
        }
    }
}
