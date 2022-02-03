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
    
    @inlinable func transform(_ bounds: Bounds) -> Self {
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
