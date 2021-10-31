//
//  &Range.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-24.
//

// MARK: - Range

extension Range {
    
    // MARK: Transformations
    
    @inlinable func map<Value>(bounds transform: (Bound) -> Value) -> Range<Value> {
        transform(lowerBound) ..< transform(upperBound)
    }
}
