//
//  NumericTextSchemeIntegers.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextSchemeOfInteger

/// NumericTextSchemeOfInteger.
///
/// - Supports all values from Number.min to Number.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
public struct NumericTextSchemeOfInteger<Value: NumericTextIntegerSubject>: NumericTextIntegerScheme {
    public typealias FormatStyle = IntegerFormatStyle<Value>
    
    // MARK: Values
    
    @inlinable public static var minLosslessValue: Value { Value.minLosslessValue }
    @inlinable public static var maxLosslessValue: Value { Value.maxLosslessValue }
    
    // MARK: Precision
    
    @inlinable public static var maxLosslessDigits: Int { Value.maxLosslessDigits }
    
    // MARK: Components

    @inlinable public static func value(_ components: NumericTextComponents) -> Value? {
        Value.init(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - NumericTextInteger

public protocol NumericTextInteger: NumericTextIntegerSubject where NumericTextScheme == NumericTextSchemeOfInteger<Self> { }
public protocol NumericTextIntegerSubject: NumericTextValue, FixedWidthInteger {
    @inlinable init?(_ description: String)
    
    @inlinable static var minLosslessValue: Self { get }
    @inlinable static var maxLosslessValue: Self { get }
    @inlinable static var maxLosslessDigits: Int { get }
}

public extension NumericTextIntegerSubject {
    @inlinable static var minLosslessValue: Self { min }
    @inlinable static var maxLosslessValue: Self { max }
}

// MARK: - Ints

extension Int: NumericTextInteger {
    public static let maxLosslessDigits: Int = String(maxLosslessValue).count
}

extension Int8: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

extension Int16: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 5 }
}

extension Int32: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 10 }
}

extension Int64: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 19 }
}

// MARK: - UInts

extension UInt: NumericTextInteger {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var minLosslessValue: UInt {
        UInt(Int.minLosslessValue)
    }
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
}

extension UInt8: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

extension UInt16: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 5 }
}

extension UInt32: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 10 }
}

extension UInt64: NumericTextInteger {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var minLosslessValue: UInt64 {
        UInt64(Int64.minLosslessValue)
    }
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }
        
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
}

#endif
