//
//  NumericTextSchemeIntegers.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextSchemeOfInteger

/// NumericTextSchemeOfInteger.
///
/// - Supports all values from Number.min to Number.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
public struct NumericTextSchemeOfInteger<Number: NumericTextSchemeOfIntegerSubject>: NumericTextIntegerScheme {
    public typealias FormatStyle = IntegerFormatStyle<Number>
    
    // MARK: Values
    
    @inlinable public static var min: Number { Number.minValue }
    @inlinable public static var max: Number { Number.maxValue }
    
    // MARK: Precision
    
    @inlinable public static var maxTotalDigits: Int { Number.maxSignificands }
    
    // MARK: Components

    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        Number.init(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - NumericTextSchemeOfIntegerSubject

public protocol NumericTextSchemeOfIntegerSubject: FixedWidthInteger {
    @inlinable init?(_ description: String)
    
    @inlinable static var minValue: Self { get }
    @inlinable static var maxValue: Self { get }
    @inlinable static var maxSignificands: Int { get }
}

extension NumericTextSchemeOfIntegerSubject {
    @inlinable public static var minValue: Self { min }
    @inlinable public static var maxValue: Self { max }
}

// MARK: - NumericTextIntegerSchemeOfSchematic

public protocol NumericTextSchemeOfIntegerSchematic: NumericTextSchematic, NumericTextSchemeOfIntegerSubject where NumericTextScheme == NumericTextSchemeOfInteger<Self> { }

// MARK: - Ints

extension Int: NumericTextSchemeOfIntegerSchematic {
    public static let maxSignificands: Int = String(max).count
}

extension Int8: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 3 }
}

extension Int16: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 5 }
}

extension Int32: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 10 }
}

extension Int64: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 19 }
}

// MARK: - UInts

extension UInt: NumericTextSchemeOfIntegerSchematic {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxValue: UInt {
        UInt(Int.maxValue)
    }
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxSignificands: Int {
        Int64.maxSignificands
    }
}

extension UInt8: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 3 }
}

extension UInt16: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 5 }
}

extension UInt32: NumericTextSchemeOfIntegerSchematic {
    @inlinable public static var maxSignificands: Int { 10 }
}

extension UInt64: NumericTextSchemeOfIntegerSchematic {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxValue: UInt64 {
        UInt64(Int64.maxValue)
    }
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxSignificands: Int {
        Int64.maxSignificands
    }
}
