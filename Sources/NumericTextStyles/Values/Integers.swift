//
//  Integers.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Integer

/// Numeric text value protocol for ordinary integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
///
@usableFromInline protocol Integer: NumberTextValue, UsesIntegerPrecision, FixedWidthInteger {
    
    // MARK: Requirements
        
    @inlinable init?(_ description: String)
    
    @inlinable static var options: Options { get }
}

// MARK: - Integer: Details

extension Integer {
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }

    // MARK: Formattable

    @inlinable public static func value(description: String) -> Self? {
        .init(description)
    }

    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
    
    // MARK: Parsable
    
    @inlinable public static var parser: NumberParser {
        .standard.options(options)
    }
}

// MARK: - UInt

extension UInt: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        [.unsigned, .integer]
    }
        
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

extension UInt8: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        [.unsigned, .integer]
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - UInt16

extension UInt16: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        [.unsigned, .integer]
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 5 }
}

// MARK: - UInt32

extension UInt32: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        [.unsigned, .integer]
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 10 }
}

// MARK: - UInt64

extension UInt64: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        [.unsigned, .integer]
    }
    
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

extension Int: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        .integer
    }
    
    public static let maxLosslessTotalDigits: Int = String(maxLosslessValue).count
}

// MARK: - Int8

extension Int8: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        .integer
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 3 }
}

// MARK: - Int16

extension Int16: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        .integer
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 5 }
}

// MARK: - Int32

extension Int32: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        .integer
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 10 }
}

// MARK: Int64

extension Int64: Integer {
    
    // MARK: Implementation
    
    @inlinable static var options: Options {
        .integer
    }
    
    @inlinable public static var maxLosslessTotalDigits: Int { 19 }
}
