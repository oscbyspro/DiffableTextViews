//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Similarities<LHS: Collection, RHS: Collection> where LHS.Element == RHS.Element, LHS.Element: Equatable {
    @usableFromInline typealias Element = LHS.Element
    @usableFromInline typealias Options = SimilaritiesOptions<Element>
    
    // MARK: Properties
    
    @usableFromInline let lhs: LHS
    @usableFromInline let rhs: RHS
    @usableFromInline let options: Options
    
    // MARK: Initializers
    
    /// - Complexity: O(1).
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options) {
        self.lhs = lhs
        self.rhs = rhs
        self.options = options
    }
    
    // MARK: Maps
    
    /// - Complexity: O(1).
    @inlinable func make<L: Collection, R: Collection>(_ lhs: L, _ rhs: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: lhs, and: rhs, with: options)
    }
    
    // MARK: Helpers
    
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func next<C: Collection>(in collection: C, from index: C.Index) -> C.Index? where C.Element == Element {
        collection.suffix(from: index).firstIndex(where: options.relevant)
    }

    // MARK: Methods
    
    /// - Complexity: O(n), where n is the length of the collection (lhs).
    @usableFromInline func prefixLHS() -> LHS.SubSequence {
        var currentLHS = lhs.startIndex
        var currentRHS = rhs.startIndex
        
        while currentLHS < lhs.endIndex, currentRHS < rhs.endIndex {
            guard let nextLHS = next(in: lhs, from: currentLHS) else { break }
            guard let nextRHS = next(in: rhs, from: currentRHS) else { break }
            
            guard lhs[nextLHS] == rhs[nextRHS] else { break }
            
            currentLHS = lhs.index(after: nextLHS)
            currentRHS = rhs.index(after: nextRHS)
        }
        
        if options.overshoot, currentLHS < lhs.endIndex {
            currentLHS = next(in: lhs, from: currentLHS) ?? lhs.endIndex
        }
        
        return lhs.prefix(upTo: currentLHS)
    }
    
    /// - Complexity: O(n), where n is the length of the collection (rhs).
    @inlinable func prefixRHS() -> RHS.SubSequence {
        make(rhs, lhs).prefixLHS()
    }
    
    /// - Complexity: O(n), where n is the length of the collection (lhs).
    @inlinable func suffixLHS() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = make(lhs.reversed(), rhs.reversed()).prefixLHS()
        return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    /// - Complexity: O(n), where n is the length of the collection (rhs).
    @inlinable func suffixRHS() -> RHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        make(rhs, lhs).suffixLHS()
    }
}

// MARK: -

@usableFromInline struct SimilaritiesOptions<Element> {
    @usableFromInline let relevant: (Element) -> Bool
    @usableFromInline let overshoot: Bool
    
    /// - Complexity: O(1).
    @inlinable init(relevant: @escaping (Element) -> Bool, overshoot: Bool) {
        self.relevant = relevant
        self.overshoot = overshoot
    }
    
    /// - Complexity: O(1).
    @inlinable static var defaults: Self {
        Self(relevant: { _ in true }, overshoot: false)
    }
    
    /// - Complexity: O(1).
    @inlinable static func inspect(_ relevant: @escaping (Element) -> Bool, overshoot: Bool = false) -> Self {
        Self(relevant: relevant, overshoot: overshoot)
    }
}

// MARK: - Prefix

extension Collection where Element: Equatable {
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(in: self, and: other, with: options).prefixLHS()
    }
}

// MARK: - Suffix

extension BidirectionalCollection where Element: Equatable {
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(in: self, and: other, with: options).suffixLHS()
    }
}
