//
//  SlidersStorageable.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * SlidersStorageable
//*============================================================================*

protocol SlidersStorageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
    //=------------------------------------------------------------------------=
    
    var storage: SlidersStorage { get }
}

//=----------------------------------------------------------------------------=
// MARK: SlidersStorageable - Details
//=----------------------------------------------------------------------------=

extension SlidersStorageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var limits: ClosedRange<CGFloat> {
        storage.limits
    }
    
    var values: Binding<(CGFloat, CGFloat)> {
        storage.values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    var radius: CGFloat {
        27
    }
    
    var thickness: CGFloat {
        04
    }
    
    var coordinates: UInt8 {
        33
    }
    
    var animation: Animation {
        Animation.linear(duration: 0.125)
    }
}
