//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-29.
//

import struct Sequences.Walkthrough

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
    
    @inlinable func step<T: BidirectionalCollection>(_ collection: T.Type = T.self) -> Walkthrough<T>.Step {
        switch self {
        case .forwards:  return .forwards
        case .backwards: return .backwards
        }
    }
}
