//
//  &Range.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

// MARK: - Range

extension Range {
    
    // MARK: Map
    
    @inlinable func map<Value>(bounds map: (Bound) -> Value) -> Range<Value> {
        map(lowerBound) ..< map(upperBound)
    }
}
