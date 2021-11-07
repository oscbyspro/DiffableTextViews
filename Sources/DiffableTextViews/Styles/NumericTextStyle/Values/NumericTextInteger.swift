//
//  NumericTextSchemeIntegers.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.IntegerFormatStyle

// MARK: - NumericTextInteger

/// Numeric text value for integers.
///
/// - Supports all values from Self.min to Self.max.
/// - UInt64.max is limited to Int64.max because Apple uses Int64 (2021-10-25).
public protocol NumericTextInteger: NumericTextValueAsInteger, FixedWidthInteger {
    @inlinable init?(_ description: String)
}

public extension NumericTextInteger {
    
    // MARK: Bounds
    
    @inlinable static var minLosslessValue: Self { min }
    @inlinable static var maxLosslessValue: Self { max }
    
    // MARK: Components

    @inlinable static func value(_ components: NumericTextComponents) -> Self? {
        .init(components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> IntegerFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Implementations

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
    @inlinable public static var maxLosslessValue: UInt64 {
        UInt64(Int64.maxLosslessValue)
    }
        
    /// Apple, please fix IntegerFormatStyleUInt64, it uses an Int64.
    @inlinable public static var maxLosslessDigits: Int {
        Int64.maxLosslessDigits
    }
}

#endif
