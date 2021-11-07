//
//  Integers.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle

// MARK: - ValueAsInteger

/// Numeric text value for integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
public protocol NormalInteger: NumericTextValue, Integer, FixedWidthInteger {
    @inlinable init?(_ description: String)
}

// MARK: - Details

extension NormalInteger {
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }

    // MARK: Formattable

    @inlinable public static func value(_ system: String) -> Self? {
        .init(system)
    }

    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Int

extension Int: NormalInteger {
    public static let maxLosslessDigits: Int = String(maxLosslessValue).count
}

// MARK: - Int8

extension Int8: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

// MARK: - Int16

extension Int16: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 5 }
}

// MARK: - Int32

extension Int32: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 10 }
}

// MARK: Int64

extension Int64: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 19 }
}

// MARK: - UInt

extension UInt: NormalInteger {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
}

// MARK: - UInt8

extension UInt8: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

// MARK: - UInt8

extension UInt16: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 5 }
}

// MARK: - UInt8

extension UInt32: NormalInteger {
    @inlinable public static var maxLosslessDigits: Int { 10 }
}

// MARK: - UInt8

extension UInt64: NormalInteger {
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
