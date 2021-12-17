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
    
    @inlinable static func value(_ system: String) -> Self?
    @inlinable static func style(_ locale: Locale, precision: Format.Precision, separator: Format.Separator) -> FormatStyle
}

#endif
