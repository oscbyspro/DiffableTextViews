//
//  NumericTextProtocols.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//


import Foundation
import SwiftUI

// MARK: - NumericTextStyleItem

@available(iOS 15.0, *)
public protocol NumericTextItem: NumericTextValuesItem, NumericTextPrecisionItem {
    associatedtype Style: FormatStyle where Style.FormatInput == Number, Style.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Utilities
    
    @inlinable static func number(_ components: NumericTextComponents) -> Number?
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style
}

// MARK: - NumericTextValuesItem

public protocol NumericTextValuesItem {
    associatedtype Number: Comparable
    
    // MARK: Properties: Static
    
    static var zero: Number { get }
    static var  max: Number { get }
    static var  min: Number { get }
}

// MARK: - NumericTextPrecisionItem

public protocol NumericTextPrecisionItem {
    
    // MARK: Properties: Static
        
    static var maxTotalDigits: Int { get }
    static var maxUpperDigits: Int { get }
    static var maxLowerDigits: Int { get }
}

public extension NumericTextPrecisionItem {
    
    // MARK: Properties: Static

    @inlinable static var isInteger: Bool { maxLowerDigits == 0 }
}

// MARK: - NumericTextFloat

@available(iOS 15.0, *)
public protocol NumericTextFloat: NumericTextItem { }

// MARK: - NumberTextInteger

@available(iOS 15.0, *)
public protocol NumericTextInteger: NumericTextItem { }

@available(iOS 15.0, *)
public extension NumericTextInteger {
    
    // MARK: Implementations
    
    @inlinable static var maxLowerDigits: Int { 0 }
}

// MARK: - Compatible

@available(iOS 15.0, *)
public protocol NumberTextCompatible {
    
    // MARK: Types
    
    associatedtype NumericTextItem: TextFields.NumericTextItem where NumericTextItem.Number == Self
}
