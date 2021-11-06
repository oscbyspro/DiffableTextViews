//
//  NumericTextStyleScheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumericTextStyleScheme

public protocol NumericTextScheme {
    associatedtype Value: Comparable
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Value, FormatStyle.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Values
    
    static var zero: Value { get }
    static var minLosslessValue: Value { get }
    static var maxLosslessValue: Value { get }
    
    // MARK: Precision
        
    static var maxLosslessDigits: Int { get }
    static var maxLosslessIntegerDigits: Int { get }
    static var maxLosslessDecimalDigits: Int { get }
    
    // MARK: Utilities
    
    @inlinable static func value(_ components: NumericTextComponents) -> Value?
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle
}

// MARK: - Descriptions

#warning("Rename.")
public extension NumericTextScheme {
    @inlinable static var float:   Bool { maxLosslessDecimalDigits != 0 }
    @inlinable static var integer: Bool { maxLosslessDecimalDigits == 0 }
}

// MARK: - Implementations: Numeric

public extension NumericTextScheme where Value: Numeric {
    @inlinable static var zero: Value { .zero }
}

// MARK: - NumericTextIntegerScheme

public  protocol NumericTextIntegerScheme: NumericTextScheme { }
public extension NumericTextIntegerScheme {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - NumericTextFloatScheme

public  protocol NumericTextFloatScheme: NumericTextScheme { }
public extension NumericTextFloatScheme {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}

// MARK: - NumericTextValue

public protocol NumericTextValue {
    associatedtype NumericTextScheme: DiffableTextViews.NumericTextScheme where NumericTextScheme.Value == Self
    typealias      NumericTextStyle = DiffableTextViews.NumericTextStyle<NumericTextScheme>
}

#endif
