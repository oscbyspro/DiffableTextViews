//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Style x Bounds
//*============================================================================*

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func transform(_ bounds: Bounds) -> Self {
        var result = self; result.bounds = bounds; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bounds
//=----------------------------------------------------------------------------=

public extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Value>) -> Self {
        transform(Bounds(min: limits.lowerBound, max: limits.upperBound))
    }
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Value>) -> Self {
        transform(Bounds(min: limits.lowerBound))
    }
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Value>) -> Self {
        transform(Bounds(max: limits.upperBound))
    }
}
