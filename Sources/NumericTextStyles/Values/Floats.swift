//
//  Floats.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.FloatingPointFormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumberTextFloat

/// Numeric text value protocol for ordinary floats.
/// 
/// - Range: ±Self.maxLosslessValue.
/// - Significands: Self.maxLosslessTotalDigits.
///
public protocol NumberTextFloat: NumberTextValue, PreciseFloat, BinaryFloatingPoint {
    @inlinable init?(_ description: String)
}

// MARK: - Details

public extension NumberTextFloat {
    
    
    // MARK: Boundable
    
    @inlinable static var minLosslessValue: Self {
        -maxLosslessValue
    }
    
    // MARK: Formattable

    @inlinable static func value(of description: String) -> Self? {
        .init(description)
    }
    
    @inlinable static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Float16

extension Float16: NumberTextFloat {
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

// MARK: - Float32

extension Float32: NumberTextFloat {
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 7 }
}

// MARK: - Float64

extension Float64: NumberTextFloat {
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 15 }
}
