//
//  &RangeReplaceableCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

// MARK: - RangeReplaceableCollection

extension RangeReplaceableCollection {
    
    // MARK: Transformations
    
    @inlinable func replace<R: RangeExpression, C: Collection>(_ range: R, with elements: C) -> Self where R.Bound == Self.Index, C.Element == Element {
        var copy = self; copy.replaceSubrange(range, with: elements); return copy
    }
}
