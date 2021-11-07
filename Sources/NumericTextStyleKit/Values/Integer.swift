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
@usableFromInline protocol Integer: NumericTextValue, FormatSubject, IntegerSubject, FixedWidthInteger {
    
    
    @inlinable init?(_ description: String)
}

// MARK: - BoundsSubject

extension Integer {
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }
}

// MARK: - FormatSubject

extension Integer {
    @inlinable static func value(_ components: Components) -> Self? {
        .init(components.characters())
    }

    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Int

extension Int: Integer {
    public static let maxLosslessDigits: Int = String(maxLosslessValue).count

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfInt {
        Style(locale: locale)
    }
}

// MARK: - Int8

extension Int8: Integer {
    @inlinable public static var maxLosslessDigits: Int { 3 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfInt8 {
        Style(locale: locale)
    }
}

// MARK: - Int16

extension Int16: Integer {
    @inlinable public static var maxLosslessDigits: Int { 5 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfInt16 {
        Style(locale: locale)
    }
}

// MARK: - Int32

extension Int32: Integer {
    @inlinable public static var maxLosslessDigits: Int { 10 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfInt32 {
        Style(locale: locale)
    }
}

// MARK: Int64

extension Int64: Integer {
    @inlinable public static var maxLosslessDigits: Int { 19 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfInt64 {
        Style<Self>(locale: locale)
    }
}

// MARK: - UInt

extension UInt: Integer {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfUInt {
        Style(locale: locale)
    }
}

// MARK: - UInt8

extension UInt8: Integer {
    @inlinable public static var maxLosslessDigits: Int { 3 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfUInt8 {
        Style(locale: locale)
    }
}

// MARK: - UInt8

extension UInt16: Integer {
    @inlinable public static var maxLosslessDigits: Int { 5 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfUInt16 {
        Style(locale: locale)
    }
}

// MARK: - UInt8

extension UInt32: Integer {
    @inlinable public static var maxLosslessDigits: Int { 10 }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfUInt32 {
        Style(locale: locale)
    }
}

// MARK: - UInt8

extension UInt64: Integer {
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }

    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfUInt64 {
        Style(locale: locale)
    }
}

#endif
