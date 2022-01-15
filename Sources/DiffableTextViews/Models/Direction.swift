//
//  Direction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-29.
//

//*============================================================================*
// MARK: * Direction
//*============================================================================*

@frozen @usableFromInline enum Direction {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case forwards
    case backwards
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func reversed() -> Self {
        switch self {
        case .forwards: return .backwards
        case .backwards: return .forwards
        }
    }
}
