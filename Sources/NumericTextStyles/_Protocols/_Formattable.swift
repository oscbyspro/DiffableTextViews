//
//  Formattable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Formattable

#warning("WIP")
public protocol _Formattable {
    
    // MARK: Requirements
    
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
        
    /// Interprets a system description of this type and returns an instance of it the description is valid, else it returns nil.
    ///
    /// System formatted means that fraction separators appear as dots and positive/negative signs appear as single character plus/minus prefixes, etc.
    ///
    /// - Parameters:
    ///     - description: A system formatted representation of the value.
    ///
    @inlinable static func value(of description: String) -> Self?
    
    /// Creates a format style instance configured with the function's parameters.
    @inlinable static func style(locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle
}
