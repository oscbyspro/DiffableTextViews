//
//  Format+Integers.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

import Foundation

//*============================================================================*
// MARK: * Integer
//*============================================================================*

extension IntegerFormatStyle: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.standard())
    }
}

//*============================================================================*
// MARK: * Integer x Currency
//*============================================================================*

extension IntegerFormatStyle.Currency: Format {
    
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

extension IntegerFormatStyle.Percent: Format {
        
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.standard())
    }
}