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
    
    @inlinable var animation: Animation {
        Animation.linear(duration: 0.125)
    }
    
    @inlinable var coordinates: UInt8 {
        33
    }
    
    @inlinable var radius: CGFloat {
        27
    }

    @inlinable var thickness: CGFloat {
        4
    }
}
