//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Clamp
//*============================================================================*

extension RangeExpression where Bound == Int {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable func clamped(to bounds: Range<Int>) -> Range<Int> {
        relative(to: Range(uncheckedBounds: (Int.min, Int.max))).clamped(to: bounds)
    }
    
    @inlinable func clamped(to bounds: ClosedRange<Int>) -> ClosedRange<Int> {
        ClosedRange(relative(to: Range(uncheckedBounds: (Int.min, Int.max)))).clamped(to: bounds)
    }
}
