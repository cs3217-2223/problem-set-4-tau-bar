//
//  BoardObjectWrapper.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 16/2/23.
//

import Foundation

/// Wrapper for the `BoardObject` object type. This is required to conform to `Hashable` protocol
/// while allowing the use of `BoardObject` type.
class BoardObjectWrapper: Hashable {
    var object: BoardObject

    init(object: BoardObject) {
        self.object = object
    }

    static func == (lhs: BoardObjectWrapper, rhs: BoardObjectWrapper) -> Bool {
        lhs.object.isEqual(to: rhs.object) &&
        rhs.object.isEqual(to: lhs.object)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(object))
    }
}
