//
//  BoardProtocol.swift
//  PeggleLevelDesigner
//
//  Created by Taufiq Abdul Rahman on 20/1/23.
//

protocol BoardProtocol {
    var pegs: Set<Peg> { get }

    mutating func addPeg(_ addedPeg: Peg)

    mutating func removePeg(_ removedPeg: Peg)

    mutating func removeAllPegs()

    mutating func movePeg(_ movedPeg: Peg, toPosition newPosition: Position)

    func findPegById(_ id: ObjectIdentifier) -> Peg?
}
