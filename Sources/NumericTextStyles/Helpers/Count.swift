//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count
//*============================================================================*

/// A count of a number's components.
///
/// - Value is defined as: integer + fraction - integer prefix zeros.
///
public struct Count: Equatable {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: SIMD3<Int>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(_ storage: SIMD3<Int>) {
        self.storage = storage
    }
    
    @inlinable init(value: Int, integer: Int, fraction: Int) {
        self.storage = SIMD3<Int>(value, integer, fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var value:    Int { storage.x }
    @inlinable public var integer:  Int { storage.y }
    @inlinable public var fraction: Int { storage.z }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ transform: (SIMD3<Int>, SIMD3<Int>) -> SIMD3<Int>, _ other: Self) -> Self {
        Self(transform(storage, other.storage))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Component
//=----------------------------------------------------------------------------=

extension Count {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable subscript(component: Self.Component) -> Int {
        switch component {
        case .value:    return value
        case .integer:  return integer
        case .fraction: return fraction
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func first(where predicate: (Int) -> Bool) -> Self.Component? {
        if predicate(value)    { return .value    }
        if predicate(integer)  { return .integer  }
        if predicate(fraction) { return .fraction }
        return nil
    }

    //*========================================================================*
    // MARK: * Component
    //*========================================================================*
    
    @usableFromInline enum Component { case value, integer, fraction }
}
