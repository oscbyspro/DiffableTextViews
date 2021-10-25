//
//  NumericTextSchemeDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - NumericTextSchemeDecimal

public enum NumericTextSchemeDecimal: NumericTextFloatScheme {    
    public typealias Number = Decimal
    public typealias Style = Number.FormatStyle
    
    // MARK: Values
        
    @inlinable public static var min: Number { -.greatestFiniteMagnitude }
    @inlinable public static var max: Number {  .greatestFiniteMagnitude }
    
    // MARK: Precision
 
    public static let maxTotalDigits: Int = 38
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumericTextComponents) -> Number? {
        .init(string: components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: Number + Compatible

extension NumericTextSchemeDecimal.Number: NumericTextSchematic {
    public typealias NumericTextScheme = NumericTextSchemeDecimal
}
