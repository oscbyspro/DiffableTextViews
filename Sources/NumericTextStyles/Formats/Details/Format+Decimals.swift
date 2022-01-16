//
//  Format+Decimals.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle: Format {

    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.standard())
    }
}

//*============================================================================*
// MARK: * Decimal x Currency
//*============================================================================*

extension Decimal.FormatStyle.Currency: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.currency())
    }
}

//*============================================================================*
// MARK: * Integer x Percent
//*============================================================================*

extension Decimal.FormatStyle.Percent: Format {
        
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.standard())
    }
}
