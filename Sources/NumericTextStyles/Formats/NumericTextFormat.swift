//
//  NumericTextFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

#warning("Rename as Format.")

//*============================================================================*
// MARK: * NumericTextFormat
//*============================================================================*

public protocol NumericTextFormat: FormatStyle {
    typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self
}
