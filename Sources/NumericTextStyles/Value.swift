//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Content
//*============================================================================*

@usableFromInline typealias Value = NumericTextValue; @usableFromInline enum Values {
    //=------------------------------------------=
    // MARK: Types
    //=------------------------------------------=
    @usableFromInline typealias FloatingPoint = NumericTextValue_FloatingPoint
    @usableFromInline typealias Integer = NumericTextValue_Integer
    @usableFromInline typealias Signed = NumericTextValue_Signed
    @usableFromInline typealias Unsigned = NumericTextValue_Unsigned
    //=------------------------------------------=
    // MARK: Formats
    //=------------------------------------------=
    @usableFromInline typealias Numberable = NumericTextValue_Numberable
    @usableFromInline typealias Currencyable = NumericTextValue_Currencyable
    @usableFromInline typealias Percentable = NumericTextValue_Percentable
}

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol NumericTextValue: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Formattable
    //=------------------------------------------------------------------------=
    
    associatedtype FormatStyle: Foundation.FormatStyle where
    FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable static var isInteger:  Bool { get }
    @inlinable static var isUnsigned: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self { get }
    @inlinable static var precision: Count { get }
    @inlinable static var bounds: ClosedRange<Self> { get }
}

//*============================================================================*
// MARK: * Value x Floating Point
//*============================================================================*

public protocol NumericTextValue_FloatingPoint: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValue_FloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger: Bool { false }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=

    @inlinable internal static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: max)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details - Signed Numeric
//=----------------------------------------------------------------------------=

extension NumericTextValue_FloatingPoint where Self: SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds(_ limit: Self) -> ClosedRange<Self> {
        -limit...limit
    }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

public protocol NumericTextValue_Integer: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValue_Integer {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isInteger: Bool { true }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=

    @inlinable internal static func precision(_ max: Int) -> Count {
        Count(value: max, integer: max, fraction: 0)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details - Fixed Width
//=----------------------------------------------------------------------------=

extension NumericTextValue_Integer where Self: FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds() -> ClosedRange<Self> {
        min...max
    }
}

//*============================================================================*
// MARK: * Value x Signed
//*============================================================================*

public protocol NumericTextValue_Signed: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValue_Signed {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol NumericTextValue_Unsigned: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValue_Unsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { true }
}

//*============================================================================*
// MARK: * Value x Formattable x Number
//*============================================================================*

public protocol NumericTextValue_Numberable: NumericTextValue where
FormatStyle: NumericTextStyles.NumericTextFormat_Number { }

//*============================================================================*
// MARK: * Value x Formattable x Currency
//*============================================================================*

public protocol NumericTextValue_Currencyable: NumericTextValue where
FormatStyle: NumericTextStyles.NumericTextFormat_Currencyable { }

//*============================================================================*
// MARK: * Value x Formattable x Percent
//*============================================================================*

public protocol NumericTextValue_Percentable: NumericTextValue where
FormatStyle: NumericTextStyles.NumericTextFormat_Percentable { }
