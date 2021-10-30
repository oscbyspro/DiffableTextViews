//
//  Direction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-29.
//

// MARK: - Direction

@usableFromInline enum Direction {
    case forwards
    case backwards
    
    // MARK: Initializers
    
    @inlinable init?<Position: Comparable>(from start: Position, to end: Position) {
        if      start < end { self = .forwards  }
        else if start > end { self = .backwards }
        else                { return nil }
    }
    
    // MARK: Utilities
    
    @inlinable var opposite: Direction {
        switch self {
        case .forwards:  return .backwards
        case .backwards: return .forwards
        }
    }
}
