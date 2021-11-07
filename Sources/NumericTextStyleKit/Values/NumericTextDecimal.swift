//
//  NumericTextSchemeDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

#if os(iOS)

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - NumericTextDecimal

/// - Supports up to 38 significant digits.
extension Decimal: NumericTextValueAsFloat { }
public extension Decimal {
    
    // MARK: Values
        
    @usableFromInline internal static let maxLosslessLimit = Decimal(string: String(repeating: "9", count: maxLosslessDigits))!
    @inlinable static var minLosslessValue: Self { -maxLosslessLimit }
    @inlinable static var maxLosslessValue: Self {  maxLosslessLimit }
    
    // MARK: Precision
 
    @inlinable static var maxLosslessDigits: Int { 38 }
    
    // MARK: Components
    
    @inlinable static func value(_ components: NumericTextComponents) -> Self? {
        .init(string: components.characters())
    }
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

#endif
