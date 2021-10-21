//
//  NumberTextInt.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import Foundation

@available(iOS 15.0, *)
public enum NumberTextInt: NumberTextInteger {
    public typealias Number = Int
    
    // MARK: Values
    
    public static let zero: Number = .zero
    public static let  min: Number =  .min
    public static let  max: Number =  .max
    
    // MARK: Precision
    
               public static let maxTotalDigits: Int = String(describing: Number.max).count
    @inlinable public static var maxUpperDigits: Int { maxTotalDigits }    
    
    // MARK: Style
    
    @inlinable public static func number(_ components: NumberTextComponents) -> Number? {
        guard !components.integerDigits.isEmpty else {
            return .zero
        }
        
        return .init(components.characters())
    }
    
    @inlinable public static func style(_ locale: Locale, precision: Precision, separator: Separator) -> IntegerFormatStyle<Number> {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - Number + Compatible

@available(iOS 15.0, *)
extension Int: NumberTextCompatible {
    public typealias NumberTextItem = NumberTextInt
}
