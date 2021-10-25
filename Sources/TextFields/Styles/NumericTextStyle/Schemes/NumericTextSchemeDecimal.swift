//
//  NumericTextSchemeDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - NumericTextSchemeDecimal

/// NumericTextSchemeDecimal.
///
/// - Supports up to 38 significant decimal digits: ±340,282,366,920,938,463,463,374,607,431,768,211,455 (rounded towards zero).
public enum NumericTextSchemeDecimal: NumericTextFloatScheme {    
    public typealias Number = Decimal
    public typealias FormatStyle = Number.FormatStyle
    
    // MARK: Values
        
    public static let abs = Decimal(string: "340282366920938463463374607431768211455")!
    @inlinable public static var min: Number { -abs }
    @inlinable public static var max: Number {  abs }
    
    // MARK: Precision
 
    @inlinable public static var maxTotalDigits: Int { 38 }
    
    // MARK: Components
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(string: components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeDecimal.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeDecimal
}
