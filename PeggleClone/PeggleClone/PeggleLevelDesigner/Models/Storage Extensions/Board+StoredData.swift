//
//  Board+StoredData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation
import CoreData
extension Board: StoredData {
    func toCoreDataObject(context: NSManagedObjectContext) -> NSManagedObject {
        let boardData = BoardData(context: context)
        boardData.name = name
        boardData.height = height
        boardData.width = width
        boardData.balls = Int16(balls)
        boardData.gameModeData = gameMode.toCoreDataObject(context: context) as? GameModeData

        for object in objects {
            guard let peg = object.object as? Peg,
                  let pegData = peg.toCoreDataObject(context: context) as? PegData else {
                continue
            }
            boardData.addToPegDatas(pegData)
        }

        for object in objects {
            guard let block = object.object as? Block,
                  let blockData = block.toCoreDataObject(context: context) as? BlockData else {
                continue
            }
            boardData.addToBlockDatas(blockData)
        }

        return boardData as NSManagedObject
    }

}
