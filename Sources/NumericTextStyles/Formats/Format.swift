//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol Format: FormatStyle {
    typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> Self
}
