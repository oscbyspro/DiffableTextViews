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

/// Decimal: conformance to NumericTextValue.
///
/// - Supports up to 38 significant digits.
///
extension Decimal: NumericTextValue, PreciseFloatingPoint { }; extension Decimal {
    
    // MARK: Boundable
        
    @usableFromInline static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessTotalDigits))!
    
    @inlinable @inline(__always) public static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable @inline(__always) public static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precise
 
    @inlinable @inline(__always) public static var maxLosslessTotalDigits: Int { 38 }
        
    // MARK: Formattable
    
    @inlinable @inline(__always) public static func value(description: String) -> Self? {
        .init(string: description)
    }
    
    @inlinable @inline(__always) public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
    
    // MARK: Parsable
    
    @inlinable @inline(__always) public static var parser: NumberParser {
        .standard
    }
}
