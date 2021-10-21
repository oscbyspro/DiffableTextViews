//
//  &RangeReplaceableCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

// MARK: - RangeReplaceableCollection

extension RangeReplaceableCollection {
    
    // MARK: Initialization
    
    @inlinable init(size: Int) {
        self.init()
        reserveCapacity(size)
    }
}

extension RangeReplaceableCollection {
    
    // MARK: Replace
    
    @inlinable func replace<Subrange: RangeExpression, Other: Collection>(_ subrange: Subrange, with other: Other) -> Self where Subrange.Bound == Self.Index, Other.Element == Element {
        var copy = self
        copy.replaceSubrange(subrange, with: other)
        return copy
    }
}
