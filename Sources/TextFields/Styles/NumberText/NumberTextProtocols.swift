//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//


import Foundation
import SwiftUI

// MARK: - NumberTextItem

@available(iOS 15.0, *)
public protocol NumberTextCompatible {
    associatedtype NumberTextItem: TextFields.NumberTextItem where NumberTextItem.Number == Self
}

// MARK: - NumberTextStyleItem

@available(iOS 15.0, *)
public protocol NumberTextItem: NumberTextValuesItem, NumberTextPrecisionItem {
    associatedtype Style: FormatStyle where Style.FormatInput == Number, Style.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Utilities
    
    @inlinable static func number(_ components: NumberTextComponents) -> Number?
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style
}

// MARK: - NumberTextValuesItem

public protocol NumberTextValuesItem {
    associatedtype Number: Comparable
    
    // MARK: Properties: Static
    
    static var zero: Number { get }
    static var  max: Number { get }
    static var  min: Number { get }
}

// MARK: - NumberTextPrecisionItem

public protocol NumberTextPrecisionItem {
    
    // MARK: Properties: Static
        
    static var maxTotalDigits: Int { get }
    static var maxUpperDigits: Int { get }
    static var maxLowerDigits: Int { get }
}

// MARK: NumberTextPrecisionItem: Float

public protocol NumberTextPrecisionFloat: NumberTextPrecisionItem { }

// MARK: NumberTextPrecisionItem: Integer

public protocol NumberTextPrecisionInteger: NumberTextPrecisionItem { }

public extension NumberTextPrecisionInteger {
    @inlinable static var maxLowerDigits: Int { 0 }
}
