//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//=----------------------------------------------------------------------------=
// MARK: Map - Single
//=----------------------------------------------------------------------------=

@inlinable func map(_ value: CGFloat,
from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> CGFloat {
    guard start.lowerBound != start.upperBound else { return end.lowerBound }
    let ratio = (end.upperBound - end.lowerBound) / (start.upperBound - start.lowerBound)
    return min(max(end.lowerBound, end.lowerBound + ratio * (value - start.lowerBound)), end.upperBound)
}

//=----------------------------------------------------------------------------=
// MARK:  Map - Double
//=----------------------------------------------------------------------------=

@inlinable func map(_ values: (CGFloat, CGFloat),
from start: ClosedRange<CGFloat>, to end: ClosedRange<CGFloat>) -> (CGFloat, CGFloat) {(
    map(values.0, from: start, to: end),
    map(values.1, from: start, to: end)
)}
