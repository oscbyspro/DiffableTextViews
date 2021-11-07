//
//  Integer.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle

// MARK: - Integer

/// Numeric text value for integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
@usableFromInline protocol Integer: NumericTextValueAsInteger, FixedWidthInteger {
    @inlinable init?(_ description: String)
}

extension Integer {
    
    // MARK: Bounds
    
    @inlinable static var minLosslessValue: Self { min }
    @inlinable static var maxLosslessValue: Self { max }
    
    // MARK: Utilities

    @inlinable static func value(_ components: Components) -> Self? {
        .init(components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Int

public protocol NumericTextStyleOfInt: NumericTextStyle where Value == Int { }
extension Style: NumericTextStyleOfInt where Value == Int { }

extension Int: Integer {
    @usableFromInline static let maxLosslessDigits: Int = String(maxLosslessValue).count
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfInt {
        Style(locale: locale)
    }
}

// MARK: - Int8

public protocol NumericTextStyleOfInt8: NumericTextStyle where Value == Int8 { }
extension Style: NumericTextStyleOfInt8 where Value == Int8 { }

extension Int8: Integer {
    @inlinable public static var maxLosslessDigits: Int { 3 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfInt8 {
        Style(locale: locale)
    }
}

// MARK: - Int16

public protocol NumericTextStyleOfInt16: NumericTextStyle where Value == Int16 { }
extension Style: NumericTextStyleOfInt16 where Value == Int16 { }

extension Int16: Integer {
    @inlinable public static var maxLosslessDigits: Int { 5 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfInt16 {
        Style(locale: locale)
    }
}

// MARK: - Int32

public protocol NumericTextStyleOfInt32: NumericTextStyle where Value == Int32 { }
extension Style: NumericTextStyleOfInt32 where Value == Int32 { }

extension Int32: Integer {
    @inlinable public static var maxLosslessDigits: Int { 10 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfInt32 {
        Style(locale: locale)
    }
}

// MARK: Int64

public protocol NumericTextStyleOfInt64: NumericTextStyle where Value == Int64 { }
extension Style: NumericTextStyleOfInt64 where Value == Int64 { }

extension Int64: Integer {
    @inlinable public static var maxLosslessDigits: Int { 19 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfInt64 {
        Style(locale: locale)
    }
}

// MARK: - UInt

public protocol NumericTextStyleOfUInt: NumericTextStyle where Value == UInt { }
extension Style: NumericTextStyleOfUInt where Value == UInt { }

extension UInt: Integer {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfUInt {
        Style(locale: locale)
    }
}

// MARK: - UInt8

public protocol NumericTextStyleOfUInt8: NumericTextStyle where Value == UInt8 { }
extension Style: NumericTextStyleOfUInt8 where Value == UInt8 { }

extension UInt8: Integer {
    @inlinable public static var maxLosslessDigits: Int { 3 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfUInt8 {
        Style(locale: locale)
    }
}

// MARK: - UInt8

public protocol NumericTextStyleOfUInt16: NumericTextStyle where Value == UInt16 { }
extension Style: NumericTextStyleOfUInt16 where Value == UInt16 { }

extension UInt16: Integer {
    @inlinable public static var maxLosslessDigits: Int { 5 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfUInt16 {
        Style(locale: locale)
    }
}

// MARK: - UInt8

public protocol NumericTextStyleOfUInt32: NumericTextStyle where Value == UInt32 { }
extension Style: NumericTextStyleOfUInt32 where Value == UInt32 { }

extension UInt32: Integer {
    @inlinable public static var maxLosslessDigits: Int { 10 }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfUInt32 {
        Style(locale: locale)
    }
}

// MARK: - UInt8

public protocol NumericTextStyleOfUInt64: NumericTextStyle where Value == UInt64 { }
extension Style: NumericTextStyleOfUInt64 where Value == UInt64 { }

extension UInt64: Integer {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }
        
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
    
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfUInt64 {
        Style(locale: locale)
    }
}

#endif
