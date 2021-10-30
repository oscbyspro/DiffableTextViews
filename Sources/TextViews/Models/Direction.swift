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
    
    // MARK: Utilities
    
    @inlinable var opposite: Direction {
        switch self {
        case .forwards: return .backwards
        case .backwards: return .forwards
        }
    }
}
