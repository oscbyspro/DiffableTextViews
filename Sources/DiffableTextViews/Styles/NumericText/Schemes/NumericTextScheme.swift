//
//  NumericTextStyleScheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import Foundation

// MARK: - NumericTextStyleScheme

public protocol NumericTextScheme {
    associatedtype Number: Comparable
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Number, FormatStyle.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Values
    
    static var zero: Number { get }
    static var  max: Number { get }
    static var  min: Number { get }
    
    // MARK: Precision
        
    static var maxTotalDigits: Int { get }
    static var maxUpperDigits: Int { get }
    static var maxLowerDigits: Int { get }
    
    // MARK: Utilities
    
    @inlinable static func number(_ components: NumericTextComponents) -> Number?
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle
}


public extension NumericTextScheme {
    
    // MARK: Descriptions

    @inlinable static var isFloat:   Bool { maxLowerDigits != 0 }
    @inlinable static var isInteger: Bool { maxLowerDigits == 0 }
}


public extension NumericTextScheme where Number: Numeric {
    
    // MARK: Implementations: Numeric
    
    @inlinable static var zero: Number { .zero }
}

// MARK: - NumericTextIntegerScheme

public  protocol NumericTextIntegerScheme: NumericTextScheme { }
public extension NumericTextIntegerScheme {
    @inlinable static var maxUpperDigits: Int { maxTotalDigits }
    @inlinable static var maxLowerDigits: Int { 0 }
}

// MARK: - NumericTextFloatScheme

public  protocol NumericTextFloatScheme: NumericTextScheme { }
public extension NumericTextFloatScheme {
    @inlinable static var maxUpperDigits: Int { maxTotalDigits }
    @inlinable static var maxLowerDigits: Int { maxTotalDigits }
}

// MARK: - NumericTextSchematic

public protocol NumericTextSchematic {
    associatedtype NumericTextScheme: TextViews.NumericTextScheme where NumericTextScheme.Number == Self
    typealias      NumericTextStyle = TextViews.NumericTextStyle<NumericTextScheme>
}

#endif
