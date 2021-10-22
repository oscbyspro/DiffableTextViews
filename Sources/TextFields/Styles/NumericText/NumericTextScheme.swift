//
//  NumericTextProtocols.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//


import Foundation
import SwiftUI

// MARK: - NumericTextStyleScheme

@available(iOS 15.0, *)
public protocol NumericTextScheme {
    associatedtype Number: Comparable
    associatedtype Style: FormatStyle where Style.FormatInput == Number, Style.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Static: Values
    
    static var zero: Number { get }
    static var  max: Number { get }
    static var  min: Number { get }
    
    // MARK: Properties: Static
        
    static var maxTotalDigits: Int { get }
    static var maxUpperDigits: Int { get }
    static var maxLowerDigits: Int { get }
    
    // MARK: Utilities
    
    @inlinable static func number(_ components: NumericTextComponents) -> Number?
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style
}

@available(iOS 15.0, *)
public extension NumericTextScheme {
    
    // MARK: Properties: Static

    @inlinable static var isInteger: Bool { maxLowerDigits == 0 }
}

// MARK: - NumericTextIntegerScheme

@available(iOS 15.0, *)
public protocol NumericTextInteger: NumericTextScheme { }

@available(iOS 15.0, *)
public extension NumericTextInteger {
    
    // MARK: Implementations
    
    @inlinable static var maxLowerDigits: Int { 0 }
}

// MARK: - NumericTextFloatScheme

@available(iOS 15.0, *)
public protocol NumericTextFloat: NumericTextScheme { }
