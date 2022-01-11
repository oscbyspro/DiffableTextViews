//
//  Formattable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import Foundation
import Utilities

//*============================================================================*
// MARK: * Formattable
//*============================================================================*

public protocol Formattable {
    typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy

    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    associatedtype FormatStyle: Foundation.ParseableFormatStyle
    where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
        
    //=------------------------------------------------------------------------=
    // MARK: Make
    //=------------------------------------------------------------------------=
    
    /// Interprets a system description of this type and returns an instance of it the description is valid, else it returns nil.
    ///
    /// System formatted means that fraction separators appear as dots and positive/negative signs appear as single character plus/minus prefixes, etc.
    ///
    /// - Parameters:
    ///     - description: A system formatted representation of the value.
    ///
    @inlinable static func make(description: String) -> Optional<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    /// Creates a format style instance configured with the function's parameters.
    @inlinable static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle
}

//=----------------------------------------------------------------------------=
// MARK: Formattable - Utilities
//=----------------------------------------------------------------------------=

extension Formattable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(number: Number) throws {
        let description = number.characters()
        
        guard let instance = Self.make(description: description) else {
            throw Info(["unable to instantiate number with description", .mark(description)])
        }
        
        self = instance
    }
}

//*============================================================================*
// MARK: * Formattable x Floating Point
//*============================================================================*

@usableFromInline protocol FormattableFloatingPoint: Formattable, BinaryFloatingPoint where FormatStyle == FloatingPointFormatStyle<Self> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init?(_ description: String)
}

//=----------------------------------------------------------------------------=
// MARK: Formattable x Floating Point - Implementation
//=----------------------------------------------------------------------------=

extension FormattableFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Make
    //=------------------------------------------------------------------------=

    @inlinable public static func make(description: String) -> Optional<Self> {
        .init(description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

//*============================================================================*
// MARK: * Formattable x Integer
//*============================================================================*

@usableFromInline protocol FormattableInteger: Formattable, FixedWidthInteger where FormatStyle == IntegerFormatStyle<Self> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init?(_ description: String)
}

//=----------------------------------------------------------------------------=
// MARK: Formattable x Integer - Implementation
//=----------------------------------------------------------------------------=

extension FormattableInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Make
    //=------------------------------------------------------------------------=
    
    @inlinable public static func make(description: String) -> Optional<Self> {
        .init(description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
