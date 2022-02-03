//
//  Storage.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Storage
//*============================================================================*

@usableFromInline final class Storage: Storageable {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let limits: ClosedRange<CGFloat>
    @usableFromInline let values: Binding<(CGFloat, CGFloat)>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.limits = limits
        self.values = values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var storage: Storage { self }

    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
    
    #warning("Make this global in new package.")
    @inlinable func ratio(_ dividend: CGFloat, _ divisor: CGFloat) -> CGFloat {
        divisor == 0 ? 0 : dividend / divisor
    }
    
    #warning("...")
    @inlinable func value(_ position: CGFloat, in bounds: CGSize) -> CGFloat {
        let position = min(max(0,  position), bounds.width)
        let multiple = ratio(limits.upperBound - limits.lowerBound, bounds.width)
        return limits.lowerBound + position * multiple
    }
    
    #warning("Move this to Layout init, maybe.")
    @inlinable func positions(in bounds: CGSize) -> (CGFloat, CGFloat) {
        let multiple = ratio(bounds.width, limits.upperBound - limits.lowerBound)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func position(_ value: CGFloat) -> CGFloat {
            min(max(0, (value - limits.lowerBound) * multiple), bounds.width)
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return (position(values.wrappedValue.0), position(values.wrappedValue.1))
    }
}

