//
//  Formattable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

#if os(iOS)

// MARK: - Formattable

public protocol Formattable {
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
    
    // MARK: Utilities
        
    /// Interprets a system description this type and returns an instance of it, if the description is valid.
    ///
    /// System description means that fraction separators appear as dots and positive/negative signs appear as single character plus/minus prefixes, etc.
    ///
    /// - Parameters:
    ///     - description: A system formatted representation of the value.
    ///
    @inlinable static func value(of description: String) -> Self?
    
    @inlinable static func style(in locale: Locale, precision: NumberFormatStyleConfiguration.Precision, separator: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> FormatStyle
}

#endif
