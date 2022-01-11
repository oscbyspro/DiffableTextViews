//
//  NumericTextFormats.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle: NumericTextFormat {
    
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

extension Decimal.FormatStyle.Currency: NumericTextFormat {
    
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

extension FloatingPointFormatStyle: NumericTextFormat {
    
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

extension FloatingPointFormatStyle.Currency: NumericTextFormat {
    
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

extension IntegerFormatStyle: NumericTextFormat {
    
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

extension IntegerFormatStyle.Currency: NumericTextFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self {
        self.locale(locale).precision(precision).decimalSeparator(strategy: separator)
    }
}

