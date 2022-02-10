//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#warning("WIP")
#warning("Rename make methods")

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol NumericTextValue: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger:  Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Data
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self { get }
    @inlinable static var precision: Count { get }
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

public protocol NumericTextFloatingPoint: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: Value x Floating Point - Details
//=----------------------------------------------------------------------------=

extension NumericTextFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger: Bool { false }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=

    @inlinable public static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Value x Floating Point - Signed Numeric
//=----------------------------------------------------------------------------=

extension NumericTextFloatingPoint where Self: SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable public static func bounds(limit: Self) -> ClosedRange<Self> {
        -limit...limit
    }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

public protocol NumericTextInteger: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: Value x Integer - Details
//=----------------------------------------------------------------------------=

public extension NumericTextInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger: Bool { true }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=

    @inlinable static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Value x Integer - Fixed Width Integer
//=----------------------------------------------------------------------------=

extension NumericTextInteger where Self: FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable public static func bounds() -> ClosedRange<Self> {
        min...max
    }
}

//*============================================================================*
// MARK: * Value x Signed
//*============================================================================*

public protocol NumericTextSigned: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: Value x Signed - Details
//=----------------------------------------------------------------------------=

public extension NumericTextSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol NumericTextUnsigned: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: Value x Unsigned - Details
//=----------------------------------------------------------------------------=

public extension NumericTextUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta
    //=------------------------------------------------------------------------=
    
    @inlinable static var isUnsigned: Bool { true }
}
