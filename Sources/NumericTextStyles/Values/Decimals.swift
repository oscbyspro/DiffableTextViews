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
extension Decimal: NumericTextValue, PreciseFloatingPoint { }
extension Decimal {
    
    // MARK: Value
    
    public static let options: NumberTypeOptions = .floatingPoint
    
    // MARK: Precise
 
    public static let maxLosslessTotalDigits: Int = 38
    
    // MARK: Boundable
        
    @inlinable public static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable public static var maxLosslessValue: Self {  maxLosslessLimit }
    @usableFromInline static let maxLosslessLimit: Self = {
        Decimal(string: String(repeating: "9", count: maxLosslessTotalDigits))!
    }()
        
    // MARK: Formattable
    
    @inlinable public static func value(description: String) -> Self? {
        .init(string: description)
    }
    
    @inlinable public static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
