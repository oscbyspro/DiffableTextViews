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

@usableFromInline final class Layout: Layoutable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let frame: CGRect
    @usableFromInline let positions: (CGFloat, CGFloat)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage, proxy: GeometryProxy) {
        self.frame = proxy.frame(in: .local)
        self.positions = storage.positions(in: frame.size)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var layout: Layout { self }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    #warning("Move this to Layout init, maybe.")
//    static func positions(values: (CGFloat, CGFloat), limits: ClosedRange<CGFloat>, length: CGFloat) -> (CGFloat, CGFloat) {
//        let multiple = ratio(length, limits.upperBound - limits.lowerBound)
//        //=--------------------------------------=
//        // MARK: Single
//        //=--------------------------------------=
//        func position(_ value: CGFloat) -> CGFloat {
//            min(max(0, (value - limits.lowerBound) * multiple), length)
//        }
//        //=--------------------------------------=
//        // MARK: Double
//        //=--------------------------------------=
//        return (position(values.0), position(values.1))
//    }
}
