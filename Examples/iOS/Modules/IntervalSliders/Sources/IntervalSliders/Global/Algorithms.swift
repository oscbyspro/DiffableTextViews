//
//  Algorithms.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//=----------------------------------------------------------------------------=
// MARK: Convert - Single
//=----------------------------------------------------------------------------=

@inlinable func map(_ value: CGFloat,
    from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> CGFloat {
    guard start.lowerBound != start.upperBound else { return end.lowerBound }
    let ratio = (end.upperBound - end.lowerBound) / (start.upperBound - start.lowerBound)
    return min(max(end.lowerBound, end.lowerBound + ratio * (value - start.lowerBound)), end.upperBound)
}

//=----------------------------------------------------------------------------=
// MARK:  Convert - Double
//=----------------------------------------------------------------------------=

@inlinable func map(_ values: (CGFloat, CGFloat),
    from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> (CGFloat, CGFloat) {(
    map(values.0, from: start, to: end), map(values.1, from: start, to: end)
)}
