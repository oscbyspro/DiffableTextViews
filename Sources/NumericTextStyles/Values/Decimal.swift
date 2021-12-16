//
//  Decimal.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - Decimal

/// - Supports up to 38 significant digits.
extension Decimal: NumericTextValue, Float { }; public extension Decimal {
    
    // MARK: Boundable
        
    @usableFromInline internal static let maxLosslessLimit =
    Decimal(string: String(repeating: "9", count: maxLosslessDigits))!
    
    @inlinable static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precise
 
    @inlinable static var maxLosslessDigits: Int { 38 }
        
    // MARK: Formattable
    
    @inlinable static func value(_ system: String) -> Self? {
        .init(string: system)
    }
    
    @inlinable static func style(_ locale: Locale, precision: Format.Precision, separator: Format.Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

#endif

