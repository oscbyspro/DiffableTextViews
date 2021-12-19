//
//  Integers.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - ValueAsInteger

/// Numeric text value protocol for ordinary integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
///
public protocol NumericTextInteger: NumericTextValue, PreciseInteger, FixedWidthInteger {
    @inlinable init?(_ description: String)
}

// MARK: - Details

extension NumericTextInteger {
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }

    // MARK: Formattable

    @inlinable public static func value(of description: String) -> Self? {
        .init(description)
    }

    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Int

extension Int: NumericTextInteger {
    public static let maxLosslessDigits: Int = String(maxLosslessValue).count
}

// MARK: - Int8

extension Int8: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

// MARK: - Int16

extension Int16: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 5 }
}

// MARK: - Int32

extension Int32: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 10 }
}

// MARK: Int64

extension Int64: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 19 }
}

// MARK: - UInt

extension UInt: NumericTextInteger {
    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    @inlinable public static var maxLosslessDigits: Int {
        Int.maxLosslessDigits
    }
}

// MARK: - UInt8

extension UInt8: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

// MARK: - UInt16

extension UInt16: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 5 }
}

// MARK: - UInt32

extension UInt32: NumericTextInteger {
    @inlinable public static var maxLosslessDigits: Int { 10 }
}

// MARK: - UInt64

extension UInt64: NumericTextInteger {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
}
