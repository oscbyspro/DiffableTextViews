//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    
    @inlinable static var zero: Self { get }
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
