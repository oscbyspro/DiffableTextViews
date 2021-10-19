//
//  NumberTextDecimal.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import struct Foundation.Locale
import struct Foundation.Decimal

// MARK: - DecimalTextItem

@available(iOS 15.0, *)
public enum DecimalNumberTextItem: NumberTextStyleItem, NumberTextValuesItem, NumberTextPrecisionItem {
    public typealias Style = Decimal.FormatStyle
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
        let characters = components.characters()
        
        guard !characters.isEmpty else {
            return nil
        }
        
        return Number(string: characters)
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
