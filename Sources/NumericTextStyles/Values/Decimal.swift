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
extension Decimal: NumberValue, _UsesFloatingPointPrecision { }; extension Decimal {
    
    // MARK: Implementation
    
    public typealias NumberParser = FloatingPointParser
    
    // MARK: Implementation: Boundable
        
    @usableFromInline static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessTotalDigits))!
    
    @inlinable public static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable public static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Implementation: Precise
 
    @inlinable public static var maxLosslessTotalDigits: Int { 38 }
        
    // MARK: Implementation: Formattable
    
    @inlinable public static func value(description: String) -> Self? {
        .init(string: description)
    }
    
    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
