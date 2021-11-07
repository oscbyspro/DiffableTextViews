//
//  NumericTextValue.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - NumericTextValue

@usableFromInline protocol Value: NumericTextValue {
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Values
    
    @inlinable static var zero:             Self { get }
    @inlinable static var minLosslessValue: Self { get }
    @inlinable static var maxLosslessValue: Self { get }
    
    // MARK: Precision
    
    @inlinable static var maxLosslessDigits:        Int { get }
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessDecimalDigits: Int { get }
    
    // MARK: Utilities
    
    @inlinable static func value(_ components: Components) -> Self?
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle
}

// MARK: - Descriptions

extension Value {
    @inlinable static var float:   Bool { maxLosslessDecimalDigits != 0 }
    @inlinable static var integer: Bool { maxLosslessDecimalDigits == 0 }
}

// MARK: - Implementations: Numeric

extension Value where Self: Numeric {
    @inlinable static var zero: Self { .zero }
}

// MARK: - NumericTextValueAsInteger

@usableFromInline protocol NumericTextValueAsInteger: Value { }
extension NumericTextValueAsInteger {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - NumericTextValueAsFloat

@usableFromInline protocol NumericTextValueAsFloat: Value { }
extension NumericTextValueAsFloat {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}

#endif
