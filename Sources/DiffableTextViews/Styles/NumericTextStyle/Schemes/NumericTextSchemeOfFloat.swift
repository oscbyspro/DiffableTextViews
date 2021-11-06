//
//  NumericTextSchemeOfFloat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.FloatingPointFormatStyle

// MARK: - NumericTextSchemeOfFloat

/// NumericTextSchemeOfFloat.
///
/// - Range: ±Number.maxLosslessValue.
/// - Significands: Number.maxLosslessSignificands
public struct NumericTextSchemeOfFloat<Value: NumericTextFloatSubject>: NumericTextFloatScheme {
    public typealias FormatStyle = FloatingPointFormatStyle<Value>
    
    // MARK: Values
    
    @inlinable public static var minLosslessValue: Value { -Value.maxLosslessValue }
    @inlinable public static var maxLosslessValue: Value {  Value.maxLosslessValue }
    
    // MARK: Precision
    
    @inlinable public static var maxLosslessDigits: Int { Value.maxLosslessDigits }

    // MARK: Components

    @inlinable public static func value(_ components: NumericTextComponents) -> Value? {
        .init(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - NumericTextSchemeOfFloatSchematic

public protocol NumericTextFloat: NumericTextFloatSubject where NumericTextScheme == NumericTextSchemeOfFloat<Self> { }
public protocol NumericTextFloatSubject: NumericTextValue, BinaryFloatingPoint {
    @inlinable init?(_ description: String)
    
    @inlinable static var maxLosslessValue: Self { get }
    @inlinable static var maxLosslessDigits: Int { get }
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
