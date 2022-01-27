//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

/// A count of a number's components.
public struct Count {

    //=------------------------------------------------------------------------=
    // MARK: Properties
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
    
    @inlinable var value:    Int { storage.x }
    @inlinable var integer:  Int { storage.y }
    @inlinable var fraction: Int { storage.z }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ transform: (SIMD3<Int>, SIMD3<Int>) -> SIMD3<Int>, _ other: Self) -> Self {
        Self(transform(storage, other.storage))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Count - Component
//=----------------------------------------------------------------------------=

extension Count {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable subscript(component: Component) -> Int {
        switch component {
        case .value:    return value
        case .integer:  return integer
        case .fraction: return fraction
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func first(where predicate: (Int) -> Bool) -> Component? {
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
