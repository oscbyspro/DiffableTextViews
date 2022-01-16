//
//  Format+FloatingPoints.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

import Foundation

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.standard())
    }
}

//*============================================================================*
// MARK: * Floating Point x Currency
//*============================================================================*

extension FloatingPointFormatStyle.Currency: Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.currency())
    }
}


//*============================================================================*
// MARK: * Floating Point x Percent
//*============================================================================*

extension FloatingPointFormatStyle.Percent: Format {
        
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        sign(strategy: style.standard())
    }
}

