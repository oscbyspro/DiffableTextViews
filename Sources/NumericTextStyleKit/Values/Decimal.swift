//
//  NumericTextSchemeDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - Decimal

public protocol NumericTextStyleOfDecimal: NumericTextStyle where Value == Decimal { }
                 extension Style: NumericTextStyleOfDecimal where Value == Decimal { }

/// - Supports up to 38 significant digits.
extension Decimal: NumericTextValueAsFloat { }
extension Decimal {
    public static func numericTextStyle(_ locale: Locale) -> some NumericTextStyleOfDecimal {
        Style<Self>(locale: locale)
    }
    
    // MARK: Bounds
        
    @usableFromInline static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessDigits))!
    
    @inlinable static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precision
 
    @inlinable static var maxLosslessDigits: Int { 38 }
    
    // MARK: Utilities

    @inlinable static func value(_ components: Components) -> Self? {
        .init(string: components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Self.Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

#endif

