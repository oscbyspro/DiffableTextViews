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

// MARK: - NumberTextValue

public protocol NumberTextValue: Parsable, Formattable, Boundable, Precise { }

// MARK: - NumberTextInteger

/// Numeric text value protocol for ordinary integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
///
@usableFromInline protocol NumberTextInteger: NumberTextValue, PreciseInteger, FixedWidthInteger {
    
    // MARK: Requirements
        
    @inlinable init?(_ description: String)
}

// MARK: - NumberTextInteger: Details

extension NumberTextInteger {
    
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
}

// MARK: - NumberTextInt

/// NumberTextInteger implementation for Int types.
@usableFromInline protocol NumberTextInt: NumberTextInteger { }; extension NumberTextInt {
    
    // MARK: Implementation
    
    @inlinable public static var parser: NumberParser {
        .standard.options(.integer)
    }
}

// MARK: - NumberTextUInt

/// NumberTextInteger implementation for UInt types.
@usableFromInline protocol NumberTextUInt: NumberTextInteger { }; extension NumberTextUInt {
    
    // MARK: Implementation
    
    @inlinable public static var parser: NumberParser {
        .standard.options(.unsignedInteger)
    }
}

// MARK: - NumberTextFloat

/// Numeric text value protocol for ordinary floats.
///
/// - Range: ±Self.maxLosslessValue.
/// - Significands: Self.maxLosslessTotalDigits.
///
@usableFromInline protocol NumberTextFloat: NumberTextValue, PreciseFloatingPoint, BinaryFloatingPoint {
    
    // MARK: Requirements
    
    @inlinable init?(_ description: String)
}

// MARK: - NumberTextFloatingPoint: Details

extension NumberTextFloat {
    
    // MARK: Boundable
    
    @inlinable public static var minLosslessValue: Self {
        -maxLosslessValue
    }
    
    // MARK: Formattable

    @inlinable public static func value(description: String) -> Self? {
        .init(description)
    }
    
    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
    
    // MARK: Parsable
    
    @inlinable public static var parser: NumberParser {
        .standard
    }
}
