//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Sign
//*============================================================================*

/// A system representation of a sign.
public enum Sign: UInt8, Unicodeable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case positive = 43 // "+"
    case negative = 45 // "-"
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let system: [Character: Self] = system()
    
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
        
        @inlinable func standard() -> NumberFormatStyleConfiguration.SignDisplayStrategy {
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
