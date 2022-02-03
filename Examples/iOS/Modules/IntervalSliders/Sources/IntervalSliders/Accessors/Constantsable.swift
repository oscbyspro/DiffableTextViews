//
//  Constantsable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Constantsable
//*============================================================================*

@usableFromInline protocol Constantsable { }

//=------------------------------------------------------------------------=
// MARK: Constantsable - Details
//=------------------------------------------------------------------------=

extension Constantsable {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @inlinable var radius: CGFloat {
        27
    }

    @inlinable var thickness: CGFloat {
        4
    }
    
    #warning("Does it still work as CoordinateSpace?")
    @inlinable var coordinates: UInt8 {
        33
    }
    
    @inlinable var animation: Animation {
        Animation.linear(duration: 0.125)
    }
}
