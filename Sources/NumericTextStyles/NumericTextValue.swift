//
//  NumberTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle
import struct Foundation.FloatingPointFormatStyle
import enum Foundation.NumberFormatStyleConfiguration
import struct Utilities.Reason

// MARK: - NumberTextValue

public protocol NumericTextValue: Formattable, Boundable, Precise {
    
    // MARK: Requirements
    
    @inlinable static var options: NumericTextOptions { get }
}

// MARK: - NumberTextValue: Details

extension NumericTextValue {
    
    // MARK: Errors
    
    @inlinable static func failure(make description: String) -> Reason {
        .reason("unable to make number with description", description)
    }
}

#warning("Mode specialization protocols to their appropriate files.")

// MARK: - NumericTextInteger

/// Numeric text value protocol for ordinary integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
///
@usableFromInline protocol NumericTextInteger: NumericTextValue, PreciseInteger, FixedWidthInteger {
    
    // MARK: Requirements
        
    @inlinable init?(_ description: String)
}

// MARK: - NumericTextInteger: Details

extension NumericTextInteger {
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self { min }
    @inlinable public static var maxLosslessValue: Self { max }

    // MARK: Formattable

    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
    
    @inlinable public static func make(description: String) throws -> Self {
        try Self(description) ?? { throw failure(make: description) }()
    }
}

// MARK: - NumericTextInt

/// NumericTextInteger implementation for Int types.
@usableFromInline protocol NumericTextInt: NumericTextInteger { }
extension NumericTextInt {
    
    // MARK: Implementation
    
    @inlinable public static var options: NumericTextOptions {
        .integer
    }
}

// MARK: - NumericTextUInt

/// NumericTextInteger implementation for UInt types.
@usableFromInline protocol NumericTextUInt: NumericTextInteger { }
extension NumericTextUInt {
    
    // MARK: Implementation
    
    @inlinable public static var options: NumericTextOptions {
        .unsignedInteger
    }
}

// MARK: - NumericTextFloat

/// Numeric text value protocol for ordinary floats.
///
/// - Range: ±Self.maxLosslessValue.
/// - Significands: Self.maxLosslessTotalDigits.
///
@usableFromInline protocol NumericTextFloat: NumericTextValue, PreciseFloatingPoint, BinaryFloatingPoint {
    
    // MARK: Requirements
    
    @inlinable init?(_ description: String)
}

// MARK: - NumericTextFloat: Details

extension NumericTextFloat {
    
    // MARK: Value
    
    @inlinable public static var options: NumericTextOptions {
        .floatingPoint
    }
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self {
        -maxLosslessValue
    }
    
    // MARK: Formattable
    
    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
    
    @inlinable public static func make(description: String) throws -> Self {
        try Self(description) ?? { throw failure(make: description) }()
    }
}
