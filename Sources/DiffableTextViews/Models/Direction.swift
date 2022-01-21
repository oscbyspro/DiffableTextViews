//
//  Direction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-29.
//

//*============================================================================*
// MARK: * Direction
//*============================================================================*

/// A forwards/backwards model.
@frozen @usableFromInline enum Direction {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case forwards
    case backwards
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init?<Value: Comparable>(start: Value, end: Value) {
        if start < end { self = .forwards }
        else if start > end { self = .backwards }
        else { return nil }
    }
    
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
