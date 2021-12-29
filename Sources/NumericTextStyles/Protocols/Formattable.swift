//
//  Formattable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import Foundation
import Utilities

// MARK: - Formattable

public protocol Formattable {
    typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Requirements
    
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
        
    /// Interprets a system description of this type and returns an instance of it the description is valid, else it returns nil.
    ///
    /// System formatted means that fraction separators appear as dots and positive/negative signs appear as single character plus/minus prefixes, etc.
    ///
    /// - Parameters:
    ///     - description: A system formatted representation of the value.
    ///
    @inlinable static func make(description: String) throws -> Self
    
    /// Creates a format style instance configured with the function's parameters.
    @inlinable static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle
}

// MARK: - Formattable: Details

extension Formattable {
    
    // MARK: Errors
    
    @inlinable static func error(make description: String) -> Reason {
        .reason("unable to instantiate number with description", description)
    }
}

// MARK: - FormattableFloat

@usableFromInline protocol FormattableFloat: Formattable, BinaryFloatingPoint where FormatStyle == FloatingPointFormatStyle<Self> {
    
    // MARK: Requirements
    
    @inlinable init?(_ description: String)
}

// MARK: - FormattableFloat: Details

extension FormattableFloat {
    
    // MARK: Implementation

    @inlinable public static func make(description: String) throws -> Self {
        try Self(description) ?? { throw error(make: description) }()
    }
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

// MARK: - FormattableInteger

@usableFromInline protocol FormattableInteger: Formattable, FixedWidthInteger where FormatStyle == IntegerFormatStyle<Self> {
    
    // MARK: Requirements
    
    @inlinable init?(_ description: String)
}

// MARK: - FormattableInteger: Details

extension FormattableInteger {
    
    // MARK: Implementation
    
    @inlinable public static func make(description: String) throws -> Self {
        try Self(description) ?? { throw error(make: description) }()
    }
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
