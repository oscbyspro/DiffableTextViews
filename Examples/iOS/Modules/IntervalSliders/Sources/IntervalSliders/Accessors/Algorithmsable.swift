//
//  Algorithmsable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Algorithmsable
//*============================================================================*

@usableFromInline protocol Algorithmsable { }

//=----------------------------------------------------------------------------=
// MARK: Algorithmsable - Details
//=----------------------------------------------------------------------------=

extension Algorithmsable {
    
    //=------------------------------------------------------------------------=
    // MARK: Single
    //=------------------------------------------------------------------------=
    
    @inlinable static func convert(_ value: CGFloat,
        from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> CGFloat {
        guard start.lowerBound != start.upperBound else { return end.lowerBound }
        let ratio = (end.upperBound - end.lowerBound) / (start.upperBound - start.lowerBound)
        return min(max(end.lowerBound, end.lowerBound + ratio * (value - start.lowerBound)), end.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Double
    //=------------------------------------------------------------------------=

    @inlinable static func convert(_ values: (CGFloat, CGFloat),
        from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> (CGFloat, CGFloat) {(
        convert(values.0, from: start, to: end), convert(values.1, from: start, to: end)
    )}
}
