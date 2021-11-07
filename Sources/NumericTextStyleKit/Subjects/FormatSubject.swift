//
//  FormatSubject.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

// MARK: - FormatSubject

@usableFromInline protocol FormatSubject {
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Utilities
    
    @inlinable static func value(_ components: Components) -> Self?
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle
}

