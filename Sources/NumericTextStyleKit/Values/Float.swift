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
@usableFromInline protocol Float: NumericTextValueAsFloat, BinaryFloatingPoint {
    @inlinable init?(_ description: String)
}

// MARK: - Defaults

extension Float {
    
    // MARK: Bounds
    
    @inlinable static var minLosslessValue: Self { -maxLosslessValue }

    // MARK: Utilities

    @inlinable static func value(_ components: Components) -> Self? {
        .init(components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Precision.Wrapped, separator: NumericTextSeparator) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Floats

extension Float16: Float {
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessDigits: Int { 3 }
}

extension Float32: Float {
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 7 }
}

extension Float64: Float {
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 15 }
}

#endif
