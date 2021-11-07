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
@usableFromInline protocol Float: NumericTextValue, FormatSubject, FloatSubject, BinaryFloatingPoint {
    @inlinable init?(_ description: String)
}

// MARK: - BoundsSubject

extension Float {
    @inlinable public static var minLosslessValue: Self {
        -maxLosslessValue
    }
}

// MARK: - FormatSubject

extension Float {
    @inlinable static func value(_ components: Components) -> Self? {
        .init(components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FloatingPointFormatStyle<Self> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Float16

extension Float16: Float {
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessDigits: Int {   3 }
    
    public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfFloat16 {
        Style(locale: locale)
    }
}

// MARK: - Float32

extension Float32: Float {
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessDigits: Int {         7 }
    
    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfFloat32 {
        Style(locale: locale)
    }
}

// MARK: - Float64

extension Float64: Float {
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessDigits: Int { 15 }
    
    @inlinable public static func numericTextStyle(locale: Locale) -> some NumericTextStyleOfFloat64 {
        Style(locale: locale)
    }
}

#endif
