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
    
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options) {
        self.lhs = lhs
        self.rhs = rhs
        self.options = options
    }
    
    // MARK: Maps
    
    @inlinable func make<L: Collection, R: Collection>(_ lhs: L, _ rhs: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: lhs, and: rhs, with: options)
    }
    
    // MARK: Helpers
    
    @inlinable func next<C: Collection>(in collection: C, from index: C.Index) -> C.Index? where C.Element == Element {
        collection.suffix(from: index).firstIndex(where: options.relevant)
    }

    // MARK: Methods
    
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
    
    @inlinable func prefixRHS() -> RHS.SubSequence {
        make(rhs, lhs).prefixLHS()
    }
    
    @inlinable func suffixLHS() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = make(lhs.reversed(), rhs.reversed()).prefixLHS()
        return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    @inlinable func suffixRHS() -> RHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        make(rhs, lhs).suffixLHS()
    }
}

// MARK: -

@usableFromInline struct SimilaritiesOptions<Element> {
    @usableFromInline let relevant: (Element) -> Bool
    @usableFromInline let overshoot: Bool
    
    @inlinable init(relevant: @escaping (Element) -> Bool, overshoot: Bool) {
        self.relevant = relevant
        self.overshoot = overshoot
    }
    
    @inlinable static var defaults: Self {
        Self(relevant: { _ in true }, overshoot: false)
    }
    
    @inlinable static func inspect(_ relevant: @escaping (Element) -> Bool, overshoot: Bool = false) -> Self {
        Self(relevant: relevant, overshoot: overshoot)
    }
}

// MARK: - Prefix

extension Collection where Element: Equatable {
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(in: self, and: other, with: options).prefixLHS()
    }
}

// MARK: - Suffix

extension BidirectionalCollection where Element: Equatable {
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(in: self, and: other, with: options).suffixLHS()
    }
}
