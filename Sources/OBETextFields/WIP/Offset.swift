//
//  Offset.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

protocol Offset: Comparable {
    var offset: Int { get }
}

extension Offset {
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.offset < rhs.offset
    }
}
