//
//  Integers.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumberTextInteger

/// Numeric text value protocol for ordinary integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
///
public protocol NumberTextInteger: NumberTextValue, _UsesIntegerPrecision, FixedWidthInteger {
    
    // MARK: Requirements
    
    @inlinable init?(_ description: String)
}

// MARK: - NumberTextInteger: Details

extension NumberTextInteger {
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }

    // MARK: FormattableTextValue

    @inlinable public static func value(description: String) -> Self? {
        .init(description)
    }

    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - UInt

extension UInt: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextUnsignedIntegerParser
    
    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    @inlinable public static var maxLosslessValue: UInt {
        UInt(Int.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt, it uses an Int.
    @inlinable public static var maxLosslessTotalDigits: Int {
        Int.maxLosslessTotalDigits
    }
}

// MARK: - UInt8

extension UInt8: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextUnsignedIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - UInt16

extension UInt16: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextUnsignedIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 5 }
}

// MARK: - UInt32

extension UInt32: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextUnsignedIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 10 }
}

// MARK: - UInt64

extension UInt64: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextUnsignedIntegerParser
    
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }

    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessTotalDigits: Int {
        Int64.maxLosslessTotalDigits
    }
}

// MARK: - Int

extension Int: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextIntegerParser
    
    public static let maxLosslessTotalDigits: Int = String(maxLosslessValue).count
}

// MARK: - Int8

extension Int8: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - Int16

extension Int16: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 5 }
}

// MARK: - Int32

extension Int32: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 10 }
}

// MARK: Int64

extension Int64: NumberTextInteger {
    
    // MARK: Implementation
    
    public typealias NumberParser = NumberTextIntegerParser
    
    @inlinable public static var maxLosslessTotalDigits: Int { 19 }
}
