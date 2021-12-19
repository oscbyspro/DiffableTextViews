//
//  Floats.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.FloatingPointFormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumericTextFloat

/// Numeric text value protocol for normal floats.
/// 
/// - Range: ±Self.maxLosslessValue.
/// - Significands: Self.maxLosslessDigits.
///
public protocol NormalFloat: NumericTextValue, PreciseFloat, BinaryFloatingPoint {
    @inlinable init?(_ description: String)
}

// MARK: - Details

public extension NormalFloat {
    
    // MARK: Boundable
    
    @inlinable static var minLosslessValue: Self {
        -maxLosslessValue
    }
    
    // MARK: Formattable

    @inlinable static func value(of description: String) -> Self? {
        .init(description)
    }
    
    @inlinable static func style(in locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Float16

extension Float16: NormalFloat {
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

// MARK: - Float32

extension Float32: NormalFloat {
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 7 }
}

// MARK: - Float64

extension Float64: NormalFloat {
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 15 }
}

#endif
