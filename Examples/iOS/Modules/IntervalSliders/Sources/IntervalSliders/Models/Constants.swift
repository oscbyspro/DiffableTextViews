//
//  Constants.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Constants
//*============================================================================*

@usableFromInline enum Constants {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let radius: CGFloat = 27

    @usableFromInline static let thickness: CGFloat = 4
    
    #warning("Does it still work as CoordinateSpace?")
    @usableFromInline static let coordinates: UInt8 = 33
    
    @usableFromInline static let animation = Animation.linear(duration: 0.125)
}
