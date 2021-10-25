//
//  NumericTextSchemeOfFloat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

import struct Foundation.Locale
import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeOfFloat

/// NumericTextSchemeOfFloat.
///
/// - Range:  ±Number.maxLosslessValue.
/// - Significands: Number.maxLosslessSignificands
public struct NumericTextSchemeOfFloat<Number: NumericTextSchemeOfFloatSubject>: NumericTextFloatScheme {
    public typealias FormatStyle = FloatingPointFormatStyle<Number>
    
    // MARK: Values
    
    @inlinable public static var min: Number { -Number.maxLosslessValue }
    @inlinable public static var max: Number {  Number.maxLosslessValue }
    
    // MARK: Precision
    
    @inlinable public static var maxTotalDigits: Int { Number.maxLosslessSignificands }

    // MARK: Components

    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - NumericTextSchemeOfFloatSubject

public protocol NumericTextSchemeOfFloatSubject: BinaryFloatingPoint {
    @inlinable init?(_ description: String)
    
    /// Largest value where all values from it to zero (with the same number of significants) can be represented.
    @inlinable static var maxLosslessValue: Self { get }
    /// Largest number of significands all values can be represented.
    @inlinable static var maxLosslessSignificands: Int { get }
}

// MARK: - NumericTextSchemeOfFloatSchematic

public protocol NumericTextSchemeOfFloatSchematic: NumericTextSchematic, NumericTextSchemeOfFloatSubject where NumericTextScheme == NumericTextSchemeOfFloat<Self> { }

// MARK: - Floats

extension Float16: NumericTextSchemeOfFloatSchematic {
    @inlinable public static var maxLosslessValue: Self { 999 }
    @inlinable public static var maxLosslessSignificands: Int { 3 }
}

extension Float32: NumericTextSchemeOfFloatSchematic {
    @inlinable public static var maxLosslessValue: Self { 9_999_999 }
    @inlinable public static var maxLosslessSignificands: Int { 7 }
}

extension Float64: NumericTextSchemeOfFloatSchematic {
    @inlinable public static var maxLosslessValue: Self { 999_999_999_999_999 }
    @inlinable public static var maxLosslessSignificands: Int { 15 }
}
