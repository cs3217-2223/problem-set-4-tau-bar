//
//  CGPoint+FetchedData.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 22/2/23.
//

import Foundation

extension CGPoint: FetchedData {
    init(data: CGPointData) throws {
        self.init(x: data.x, y: data.y)
    }
}
