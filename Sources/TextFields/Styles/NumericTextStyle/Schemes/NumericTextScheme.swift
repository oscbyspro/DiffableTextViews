//
//  NumericTextProtocols.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import Foundation

// MARK: - NumericTextStyleScheme

public protocol NumericTextScheme {
    associatedtype Number: Comparable
    associatedtype Style: FormatStyle where Style.FormatInput == Number, Style.FormatOutput == String
    
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
    
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style
}

// MARK: - Default

public extension NumericTextScheme {
    @inlinable static var isInteger: Bool { maxLowerDigits == 0 }
}

// MARK: - Numeric

public extension NumericTextScheme where Number: Numeric {
    @inlinable static var zero: Number { .zero }
}


// MARK: - NumericTextIntegerScheme

public  protocol NumericTextIntegerScheme: NumericTextScheme { }
public extension NumericTextIntegerScheme {
    @inlinable static var maxUpperDigits: Int { maxTotalDigits }
    @inlinable static var maxLowerDigits: Int { 0 }
}

public extension NumericTextIntegerScheme where Number: FixedWidthInteger {
    @inlinable static var min: Number { .min }
    @inlinable static var max: Number { .max }
}

public extension NumericTextIntegerScheme where Style == IntegerFormatStyle<Number> {
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - NumericTextFloatScheme

public  protocol NumericTextFloatScheme: NumericTextScheme { }
public extension NumericTextFloatScheme {
    @inlinable static var maxUpperDigits: Int { maxTotalDigits }
    @inlinable static var maxLowerDigits: Int { maxTotalDigits }
}

public extension NumericTextFloatScheme where Number: FloatingPoint {
    @inlinable static var min: Number { -.greatestFiniteMagnitude }
    @inlinable static var max: Number {  .greatestFiniteMagnitude }
}

public extension NumericTextFloatScheme where Style == FloatingPointFormatStyle<Number> {
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> Style {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - NumbericTextSchemeCompatible

public protocol NumericTextSchematic {
    associatedtype NumericTextScheme: TextFields.NumericTextScheme where NumericTextScheme.Number == Self
    typealias      NumericTextStyle = TextFields.NumericTextStyle<NumericTextScheme>
}
