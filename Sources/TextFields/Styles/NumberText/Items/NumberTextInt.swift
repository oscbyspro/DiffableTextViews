//
//  NumberTextInt.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import Foundation

@available(iOS 15.0, *)
public enum NumberTextInt: NumberTextItem, NumberTextValuesItem, NumberTextPrecisionItemInteger {
    public typealias Number = Int
    public typealias Style = IntegerFormatStyle<Number>
    
    // MARK: Values
    
    public static let zero: Number = .zero
    public static let  min: Number =  .min
    public static let  max: Number =  .max
    
    // MARK: Precision
    
               public static let maxTotalDigits: Int = String(describing: Number.max).count
    @inlinable public static var maxUpperDigits: Int { maxTotalDigits }    
    
    // MARK: Conversions
    
    @inlinable public static func number(_ components: NumberTextComponents) -> Number? {
        guard components.separator.isEmpty, components.lower.isEmpty else {
            return nil
        }
        
        guard !components.upper.isEmpty else {
            return .zero
        }
        
        return Number(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Number + Compatible

@available(iOS 15.0, *)
extension Int: NumberTextCompatible {
    public typealias NumberTextItem = NumberTextInt
}
