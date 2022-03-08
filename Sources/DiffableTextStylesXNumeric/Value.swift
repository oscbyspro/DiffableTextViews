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
    @usableFromInline typealias FloatingPoint = NumericTextValueXFloatingPoint
    @usableFromInline typealias Integer       = NumericTextValueXInteger
    @usableFromInline typealias Signed        = NumericTextValueXSigned
    @usableFromInline typealias Unsigned      = NumericTextValueXUnsigned
    //=------------------------------------------=
    // MARK: Formats
    //=------------------------------------------=
    @usableFromInline typealias Numberable   = NumericTextValueXNumberable
    @usableFromInline typealias Currencyable = NumericTextValueXCurrencyable
    @usableFromInline typealias Percentable  = NumericTextValueXPercentable
}

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol NumericTextValue: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Formattable
    //=------------------------------------------------------------------------=
    
    associatedtype FormatStyle: NumericTextFormat where FormatStyle.FormatInput == Self
    
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

public protocol NumericTextValueXFloatingPoint: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValueXFloatingPoint {
    
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

extension NumericTextValueXFloatingPoint where Self: SignedNumeric {
    
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

public protocol NumericTextValueXInteger: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValueXInteger {
    
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

extension NumericTextValueXInteger where Self: FixedWidthInteger {
    
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

public protocol NumericTextValueXSigned: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValueXSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol NumericTextValueXUnsigned: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextValueXUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { true }
}

//*============================================================================*
// MARK: * Value x Formattable x Number
//*============================================================================*

public protocol NumericTextValueXNumberable: NumericTextValue where
FormatStyle: NumericTextFormatXNumber { }

//*============================================================================*
// MARK: * Value x Formattable x Currency
//*============================================================================*

public protocol NumericTextValueXCurrencyable: NumericTextValue where
FormatStyle: NumericTextFormatXCurrencyable { }

//*============================================================================*
// MARK: * Value x Formattable x Percent
//*============================================================================*

public protocol NumericTextValueXPercentable: NumericTextValue where
FormatStyle: NumericTextFormatXPercentable { }
