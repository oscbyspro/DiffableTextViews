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

@usableFromInline typealias Value = NumericTextValue; extension Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Float = NumericTextFloatValue
    @usableFromInline typealias Integer = NumericTextIntegerValue
    @usableFromInline typealias Signed = NumericTextSignedValue
    @usableFromInline typealias Unsigned = NumericTextUnsignedValue
    
    //=------------------------------------------------------------------------=
    // MARK: Formats
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Number = NumericTextNumberValue
    @usableFromInline typealias Currency = NumericTextCurrencyValue
    @usableFromInline typealias Percent = NumericTextPercentValue
}

//*============================================================================*
// MARK: * Value
//*============================================================================*

public protocol NumericTextValue: Comparable {
    
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
// MARK: * Value x Float
//*============================================================================*

public protocol NumericTextFloatValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextFloatValue {
    
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
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension NumericTextFloatValue where Self: SignedNumeric {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func bounds(limit: Self) -> ClosedRange<Self> {
        -limit...limit
    }
}

//*============================================================================*
// MARK: * Value x Integer
//*============================================================================*

public protocol NumericTextIntegerValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextIntegerValue {
    
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
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension NumericTextIntegerValue where Self: FixedWidthInteger {
    
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

public protocol NumericTextSignedValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextSignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { false }
}

//*============================================================================*
// MARK: * Value x Unsigned
//*============================================================================*

public protocol NumericTextUnsignedValue: NumericTextValue { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextUnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Kind
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isUnsigned: Bool { true }
}

//*============================================================================*
// MARK: * Value x Number
//*============================================================================*

@usableFromInline protocol NumericTextNumberValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    associatedtype Number: Format.Number where Number.FormatInput == Self
}

//*============================================================================*
// MARK: * Value x Currency
//*============================================================================*

@usableFromInline protocol NumericTextCurrencyValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    associatedtype Currency: Format.Currency where Currency.FormatInput == Self
}

//*============================================================================*
// MARK: * Value x Percent
//*============================================================================*

@usableFromInline protocol NumericTextPercentValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    associatedtype Percent: Format.Percent where Percent.FormatInput == Self
}

//*============================================================================*
// MARK: * Value x Float x Formats
//*============================================================================*

extension Value.Float where Self: Value.Number, Self: BinaryFloatingPoint {
    @usableFromInline typealias Number = FloatingPointFormatStyle<Self>
}

extension Value.Float where Self: Value.Number, Self: BinaryFloatingPoint {
    @usableFromInline typealias Currency = FloatingPointFormatStyle<Self>.Currency
}

extension Value.Float where Self: Value.Number, Self: BinaryFloatingPoint {
    @usableFromInline typealias Percent = FloatingPointFormatStyle<Self>.Percent
}

//*============================================================================*
// MARK: * Value x Integer x Formats
//*============================================================================*

extension Value.Integer where Self: Value.Number, Self: BinaryInteger {
    @usableFromInline typealias Number = IntegerFormatStyle<Self>
}

extension Value.Integer where Self: Value.Number, Self: BinaryInteger {
    @usableFromInline typealias Currency = IntegerFormatStyle<Self>.Currency
}

extension Value.Integer where Self: Value.Number, Self: BinaryInteger {
    @usableFromInline typealias Percent = IntegerFormatStyle<Self>.Percent
}
