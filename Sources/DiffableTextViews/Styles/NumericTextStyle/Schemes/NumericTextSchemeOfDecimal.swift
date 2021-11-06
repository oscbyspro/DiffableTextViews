//
//  NumericTextSchemeDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - NumericTextSchemeOfDecimal

/// NumericTextSchemeOfDecimal.
///
/// - Supports up to 38 significant digits.
public enum NumericTextSchemeOfDecimal: NumericTextFloatScheme {    
    public typealias Value = Decimal
    public typealias FormatStyle = Value.FormatStyle
    
    // MARK: Values
        
    public static let maxLosslessLimit = Decimal(string: String(repeating: "9", count: maxLosslessDigits))!
    @inlinable public static var minLosslessValue: Value { -maxLosslessLimit }
    @inlinable public static var maxLosslessValue: Value {  maxLosslessLimit }
    
    // MARK: Precision
 
    @inlinable public static var maxLosslessDigits: Int { 38 }
    
    // MARK: Components
    
    @inlinable public static func value(_ components: NumericTextComponents) -> Value? {
        .init(string: components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeOfDecimal.Value: NumericTextValue {
    public typealias NumericTextScheme = NumericTextSchemeOfDecimal
}

#endif
