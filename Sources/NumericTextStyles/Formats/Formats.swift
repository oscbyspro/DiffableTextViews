//
//  Formats.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

//*============================================================================*
// MARK: * Decimal - Currency
//*============================================================================*

extension Decimal.FormatStyle.Currency: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

//*============================================================================*
// MARK: * Floating Point - Currency
//*============================================================================*

extension FloatingPointFormatStyle.Currency: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

//*============================================================================*
// MARK: * Integer
//*============================================================================*

extension IntegerFormatStyle: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

//*============================================================================*
// MARK: * Integer - Currency
//*============================================================================*

extension IntegerFormatStyle.Currency: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

