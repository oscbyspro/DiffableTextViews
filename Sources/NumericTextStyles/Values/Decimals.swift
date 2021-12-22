//
//  Decimal.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Locale
import struct Foundation.Decimal
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Decimal

/// Decimal: conformance to NumberTextValue.
///
/// - Supports up to 38 significant digits.
///
extension Decimal: NumberTextValue, PreciseFloatingPoint { }; extension Decimal {
    
    // MARK: Boundable
        
    @usableFromInline static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessTotalDigits))!
    
    @inlinable public static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable public static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precise
 
    @inlinable public static var maxLosslessTotalDigits: Int { 38 }
        
    // MARK: Formattable
    
    @inlinable public static func value(description: String) -> Self? {
        .init(string: description)
    }
    
    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
    
    // MARK: Parsable
    
    @inlinable public static var parser: NumberParser {
        .standard
    }
}
