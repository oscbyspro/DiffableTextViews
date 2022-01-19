//
//  NumericTextStyle+Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-19.
//

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Bounds
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func bounds(_ bounds: Bounds) -> Self {
        var result = self; result.bounds = bounds; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: DiffableTextStyle - Bounds
//=----------------------------------------------------------------------------=

public extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func bounds(_ limits: ClosedRange<Value>) -> Self {
        bounds(Bounds(min: limits.lowerBound, max: limits.upperBound))
    }
    
    @inlinable @inline(__always) func bounds(_ limits: PartialRangeFrom<Value>) -> Self {
        bounds(Bounds(min: limits.lowerBound))
    }
    
    @inlinable @inline(__always) func bounds(_ limits: PartialRangeThrough<Value>) -> Self {
        bounds(Bounds(max: limits.upperBound))
    }
}
