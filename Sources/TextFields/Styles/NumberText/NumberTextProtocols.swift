//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//


import Foundation
import SwiftUI

// MARK: - NumberTextStyleItem

@available(iOS 15.0, *)
public protocol NumberTextStyleItem: NumberTextValuesItem, NumberTextPrecisionItem {
    associatedtype Style: FormatStyle where Style.FormatInput == Number, Style.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Configuration = NumberFormatStyleConfiguration
    typealias Precision = Configuration.Precision
    typealias Separator = Configuration.DecimalSeparatorDisplayStrategy
    
    // MARK: Utilities
    
    @inlinable static func number(_ components: NumberTextComponents) -> Number?
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style
}

// MARK: - NumberTextPrecisionItem

#warning("Add protocols for Integer/Float distinction that limits which static functions are available.")
public protocol NumberTextPrecisionItem {
    
    // MARK: Properties: Static
        
    static var maxTotalDigits: Int { get }
    static var maxUpperDigits: Int { get }
    static var maxLowerDigits: Int { get }
}

// MARK: - NumberTextValuesItem

public protocol NumberTextValuesItem {
    associatedtype Number: Comparable
    
    // MARK: Properties: Static
    
    static var zero: Number { get }
    static var  max: Number { get }
    static var  min: Number { get }
}
