//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * HasConstants
//*============================================================================*

@usableFromInline protocol HasConstants { }

//=------------------------------------------------------------------------=
// MARK: HasContants - Details
//=------------------------------------------------------------------------=

extension HasConstants {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @inlinable var radius: CGFloat {
        27
    }
    
    @inlinable var thickness: CGFloat {
        04
    }
    
    @inlinable var coordinates: UInt8 {
        33
    }
    
    @inlinable var animation: Animation {
        Animation.linear(duration: 0.125)
    }
}
