//
//  &RangeReplaceableCollection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

extension RangeReplaceableCollection {    
    /// - Complexity: O(n + m), where n is length of the collection and m is the length of other.
    @inlinable func replacing<Subrange: RangeExpression, Other: Collection>(_ subrange: Subrange, with other: Other) -> Self where Subrange.Bound == Self.Index, Other.Element == Element {
        var copy = self
        copy.replaceSubrange(subrange, with: other)
        return copy
    }
    
    /// - Complexity: O(n + m), where n is length of the collection and m is the length of other.
    @inlinable func replacing<Other: Collection>(_ indices: Indices, with other: Other) -> Self where Other.Element == Element {
        replacing(indices.startIndex ..< indices.endIndex, with: other)
    }
}
