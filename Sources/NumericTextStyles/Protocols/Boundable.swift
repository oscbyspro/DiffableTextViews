//
//  Boundable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

//*============================================================================*
// MARK: * Boundable
//*============================================================================*

/// A boundable value.
///
/// BoundableFloatingPoint and BoundableInteger are used as affordances by Bounds.
///
public protocol Boundable: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//*============================================================================*
// MARK: * Boundable x Floating Point
//*============================================================================*

public protocol BoundableFloatingPoint: Boundable { }

//=----------------------------------------------------------------------------=
// MARK: Boundable x Floating Point - Utilities
//=----------------------------------------------------------------------------=

extension BoundableFloatingPoint where Self: SignedNumeric {
    
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

public protocol BoundableInteger: Boundable { }

//=----------------------------------------------------------------------------=
// MARK: Boundable x Integer - Utilities
//=----------------------------------------------------------------------------=

extension BoundableInteger where Self: FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds - Make
    //=------------------------------------------------------------------------=
    
    @inlinable public static func bounds() -> ClosedRange<Self> {
        min...max
    }
}
