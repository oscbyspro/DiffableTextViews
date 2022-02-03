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

@inlinable var coordinates: UInt8 { 33 }
@inlinable var radius:    CGFloat { 27 }
@inlinable var thickness: CGFloat { 04 }

@inlinable var slide: Animation {
    Animation.linear(duration: 0.125)
}
