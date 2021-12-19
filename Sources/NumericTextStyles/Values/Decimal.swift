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
extension Decimal: NumericTextValue, PreciseFloat { }; public extension Decimal {
    
    // MARK: Boundable
        
    @usableFromInline internal static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessDigits))!
    
    @inlinable static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precise
 
    @inlinable static var maxLosslessDigits: Int { 38 }
        
    // MARK: Formattable
    
    @inlinable static func value(of description: String) -> Self? {
        .init(string: description)
    }
    
    @inlinable static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
