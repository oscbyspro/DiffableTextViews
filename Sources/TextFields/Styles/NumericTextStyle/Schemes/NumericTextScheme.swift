//
//  NumericTextProtocols.swift
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

public extension NumericTextScheme {
    
    // MARK: Properties: Static

    @inlinable static var isInteger: Bool { maxLowerDigits == 0 }
}


// MARK: - NumericTextIntegerScheme

public  protocol NumericTextIntegerScheme: NumericTextScheme { }
public extension NumericTextIntegerScheme {
    
    // MARK: Implementations
    
    @inlinable static var maxLowerDigits: Int { 0 }
}

// MARK: - NumericTextFloatScheme

public protocol NumericTextFloatScheme: NumericTextScheme { }

// MARK: - NumbericTextSchemeCompatible

public protocol NumericTextSchematic {
    associatedtype NumericTextScheme: TextFields.NumericTextScheme where NumericTextScheme.Number == Self
}

public extension NumericTextSchematic {
    typealias NumericTextStyle = TextFields.NumericTextStyle<NumericTextScheme>
}

#endif
