//
//  &Range.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

extension Range {
    @inlinable func map<Value>(bounds map: (Bound) -> Value) -> Range<Value> {
        map(lowerBound) ..< map(upperBound)
    }
}
