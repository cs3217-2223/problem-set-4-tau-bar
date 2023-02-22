//
//  StorageError.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation

enum StorageError: Error {
    case boardDoesNotExist
    case duplicateBoardName
    case invalidPegColor
    case invalidPegData
    case invalidBlockData
    case invalidBoardData
}
