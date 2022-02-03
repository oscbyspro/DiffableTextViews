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

@usableFromInline enum Algorithms {

    //=------------------------------------------------------------------------=
    // MARK: Convert
    //=------------------------------------------------------------------------=

    @inlinable static func convert(_ values: (CGFloat, CGFloat),
        from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> (CGFloat, CGFloat) {
        //=--------------------------------------=
        // MARK: Invalid
        //=--------------------------------------=
        guard start.lowerBound != start.upperBound else {
            return (end.lowerBound, end.lowerBound)
        }
        //=--------------------------------------=
        // MARK: Ratio
        //=--------------------------------------=
        let ratio = (end.upperBound - end.lowerBound) / (start.upperBound - start.lowerBound)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func convert(_ value: CGFloat) -> CGFloat {
            min(max(end.lowerBound, end.lowerBound + ratio * (value - start.lowerBound)), end.upperBound)
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return (convert(values.0), convert(values.1))
    }
}
