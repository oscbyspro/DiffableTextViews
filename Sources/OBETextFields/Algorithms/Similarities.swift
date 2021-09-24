//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: - Prefix

extension Collection {
    /// - Complexity: O(min(n, m)) where n is the length of the collection and m is the length of other.
    @usableFromInline func prefix<Other: Collection>(
        prefixing other: Other,
        comparing relevant: (Element) -> Bool,
        using equality: (Element, Element) -> Bool
    ) -> SubSequence where Other.Element == Element {
        var index: Index = startIndex
        var otherIndex: Other.Index = other.startIndex
        
        while index < endIndex, otherIndex < other.endIndex {
            guard let nextIndex: Index = suffix(from: index).firstIndex(where: relevant) else { break }
            guard let otherNextIndex: Other.Index = other.suffix(from: otherIndex).firstIndex(where: relevant) else { break }
            guard equality(self[nextIndex], other[otherNextIndex]) else { break }

            index = self.index(after: nextIndex)
            otherIndex = other.index(after: otherNextIndex)
        }

        if index < endIndex {
            index = suffix(from: index).firstIndex(where: relevant) ?? endIndex
        }

        return prefix(upTo: index)
    }
}

// MARK: - Suffix

extension BidirectionalCollection {
    /// - Complexity: O(min(n, m)) where n is the length of the collection and m is the length of other.
    @inlinable func suffix<Other: BidirectionalCollection>(
        suffixing other: Other,
        comparing relevant: (Element) -> Bool,
        using equality: (Element, Element) -> Bool
    ) -> SubSequence where Other.Element == Element {
        let reversed: ReversedCollection<Self>.SubSequence
        reversed = self.reversed().prefix(prefixing: other.reversed(), comparing: relevant, using: equality)
        return self[reversed.endIndex.base ..< reversed.startIndex.base]
    }
}
