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

@usableFromInline final class Layout: Algorithmsable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let frame: CGRect
    @usableFromInline let positions: (CGFloat, CGFloat)
    @usableFromInline let positionsLimits: ClosedRange<CGFloat>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage, proxy: GeometryProxy) {
        self.frame = proxy.frame(in: .local)
        self.positionsLimits = 0...frame.width
        self.positions = Self.convert(
        storage.values.wrappedValue, from: storage.valuesLimits, to: positionsLimits)
    }
}
