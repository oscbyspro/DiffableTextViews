//
//  Layout.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Layout
//*============================================================================*

@usableFromInline final class Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pointY: CGFloat
    @usableFromInline let values: (CGFloat, CGFloat)
    @usableFromInline let limits: ClosedRange<CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage, proxy: GeometryProxy) {
        self.pointY = proxy.size.height/2
        self.limits = 0...proxy.size.width
        self.values = Algorithms.convert(
        storage.values.wrappedValue, from: storage.limits, to: limits)
    }
}
