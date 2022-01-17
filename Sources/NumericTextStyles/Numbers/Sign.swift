//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Sign
//*============================================================================*

/// A system representation of a sign.
public enum Sign: UInt8, Unit {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case positive = 43 // "+"
    case negative = 45 // "-"
    
    //*========================================================================*
    // MARK: * Style
    //*========================================================================*
    
    public enum Style {
        @usableFromInline typealias Standard = NumberFormatStyleConfiguration.SignDisplayStrategy
        @usableFromInline typealias Currency = CurrencyFormatStyleConfiguration.SignDisplayStrategy
        
        //=--------------------------------------------------------------------=
        // MARK: Instance
        //=--------------------------------------------------------------------=
        
        case always
        case automatic
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func standard() -> Standard {
            switch self {
            case .always:    return .always()
            case .automatic: return .automatic
            }
        }
        
        @inlinable func currency() -> Currency {
            switch self {
            case .always:    return .always()
            case .automatic: return .automatic
            }
        }
    }
}
