//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Boundable
//*============================================================================*

public protocol Boundable: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//*============================================================================*
// MARK: * Boundable x Floating Point
//*============================================================================*

@usableFromInline protocol BoundableFloatingPoint: Boundable, SignedNumeric { }

//=----------------------------------------------------------------------------=
// MARK: Boundable x Floating Point - Utilities
//=----------------------------------------------------------------------------=

extension BoundableFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds - Make
    //=------------------------------------------------------------------------=
    
    @inlinable public static func bounds(limit: Self) -> ClosedRange<Self> {
        -limit...limit
    }
}

//*============================================================================*
// MARK: * Boundable x Integer
//*============================================================================*

@usableFromInline protocol BoundableInteger: Boundable, FixedWidthInteger { }

//=----------------------------------------------------------------------------=
// MARK: Boundable x Integer - Utilities
//=----------------------------------------------------------------------------=

extension BoundableInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds - Make
    //=------------------------------------------------------------------------=
    
    @inlinable static func bounds() -> ClosedRange<Self> {
        min...max
    }
}
