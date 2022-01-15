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
        
        //=--------------------------------------------------------------------=
        // MARK: Instance
        //=--------------------------------------------------------------------=
        
        case always
        case automatic
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func number() -> NumberFormatStyleConfiguration.SignDisplayStrategy {
            switch self {
            case .always:    return .always()
            case .automatic: return .automatic
            }
        }
        
        @inlinable func currency() -> CurrencyFormatStyleConfiguration.SignDisplayStrategy {
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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func toggle() {
        switch self {
        case .positive: self = .negative
        case .negative: self = .positive
        }
    }
    
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
