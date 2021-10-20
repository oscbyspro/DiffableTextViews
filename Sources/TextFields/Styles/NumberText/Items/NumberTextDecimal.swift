//
//  NumberTextDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - NumberTextDecimal

@available(iOS 15.0, *)
public enum NumberTextDecimal: NumberTextFloat {
    public typealias Number = Decimal
    
    // MARK: Values
    
    public static let zero =  Number.zero
    public static let  min = -Number(string: String(repeating: "9", count: maxTotalDigits))!
    public static let  max =  Number(string: String(repeating: "9", count: maxTotalDigits))!
    
    // MARK: Precision
 
               public static let maxTotalDigits: Int = 38
    @inlinable public static var maxUpperDigits: Int { maxTotalDigits }
    @inlinable public static var maxLowerDigits: Int { maxTotalDigits }
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumberTextComponents) -> Number? {
        .init(string: components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Number.FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Number + Compatible

@available(iOS 15.0, *)
extension Decimal: NumberTextCompatible {
    public typealias NumberTextItem = NumberTextDecimal
}

