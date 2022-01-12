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

public protocol Format: ParseableFormatStyle {
    typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: PrecisionStyle) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Separator
    //=------------------------------------------------------------------------=
    
    @inlinable func decimalSeparator(strategy: SeparatorStyle) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(style: Sign.Style) -> Self
}
