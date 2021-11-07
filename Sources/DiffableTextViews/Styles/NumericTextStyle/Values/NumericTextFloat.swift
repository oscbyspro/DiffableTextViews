//
//  NumericTextSchemeOfFloat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextFloat

/// NumericTextSchemeOfFloat.
///
/// - Range: ±Self.maxLosslessValue.
/// - Significands: Self.maxLosslessDigits.
public protocol NumericTextFloat: NumericTextValueAsFloat, BinaryFloatingPoint {
    @inlinable init?(_ description: String)
}

// MARK: - Defaults

public extension NumericTextFloat {
    
    // MARK: Values
    
    @inlinable static var minLosslessValue: Self { -maxLosslessValue }
    
    // MARK: Precision
    
    @inlinable static var maxLosslessDigits: Int { Self.maxLosslessDigits }

    // MARK: Components

    @inlinable static func value(_ components: NumericTextComponents) -> Self? {
        .init(components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Floats

extension Float16: NumericTextFloat {
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

extension Float32: NumericTextFloat {
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 7 }
}

extension Float64: NumericTextFloat {
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 15 }
}

#endif
