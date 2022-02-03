//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Algorithms
//*============================================================================*

#warning("Turn this into a protocol.")
@usableFromInline enum Algorithms {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=

    @inlinable static func convert(_ value: CGFloat,
        from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> CGFloat {
        //=--------------------------------------=
        // MARK: Invalid
        //=--------------------------------------=
        guard start.lowerBound != start.upperBound else { return end.lowerBound }
        //=--------------------------------------=
        // MARK: Ratio
        //=--------------------------------------=
        let ratio = (end.upperBound - end.lowerBound) / (start.upperBound - start.lowerBound)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        return min(max(end.lowerBound, end.lowerBound + ratio * (value - start.lowerBound)), end.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable static func convert(_ values: (CGFloat, CGFloat),
        from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> (CGFloat, CGFloat) {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func next(_ value: CGFloat) -> CGFloat {
            convert(value, from: start, to: end)
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return (next(values.0), next(values.1))
    }
}
