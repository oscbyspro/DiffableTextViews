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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable func precision(_ precision: PrecisionStyle) -> Self
    
    @inlinable func decimalSeparator(strategy: SeparatorStyle) -> Self
}
