//
//  BoardObject.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 15/2/23.
//

import Foundation

protocol BoardObject: AnyObject {
    var position: CGPoint { get set }
    var rotation: Double { get set }
    var height: Double { get }
    var width: Double { get }
    var asset: String { get }

    func isOverlapping(with otherObject: BoardObject) -> Bool
    func isOverlapping(with otherObject: Peg) -> Bool
    func isOverlapping(with otherObject: Block) -> Bool
    func isEqual(to otherObject: BoardObject) -> Bool

    ///  Checks whether the object  is within the specified bounds,
    /// - Parameters:
    ///   - lowerX: The lowest allowed x position.
    ///   - upperX: The largest allowed x position.
    ///   - lowerY: The lowest allowed  y position.
    ///   - upperY: The largest allowed y position.
    /// - Returns: Whether the object  is within the specified bounds.
    func isOutOfBounds(lowerX: Double, upperX: Double, lowerY: Double, upperY: Double) -> Bool
}
