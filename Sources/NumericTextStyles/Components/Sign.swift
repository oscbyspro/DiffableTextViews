//
//  Sign.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

#warning("Clean this up.")

import Foundation

//*============================================================================*
// MARK: * Sign
//*============================================================================*

/// A system representation of a sign.
public enum Sign: Character, Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case positive = "+"
    case negative = "-"
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .positive
    }
    
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

//=----------------------------------------------------------------------------=
// MARK: Sign - Utilities
//=----------------------------------------------------------------------------=

extension Sign {
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Characters: TextOutputStream>(characters: inout Characters, in region: Region) {
        region.signsInLocale[self]?.write(to: &characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sign - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Sign: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        switch self {
        case .positive: return "positive"
        case .negative: return "negative"
        }
    }
}
