//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline
struct Similarites<Element: Equatable, LHS: Collection, RHS: Collection> where LHS.Element == Element, RHS.Element == Element {
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
    
    // MARK: Helpers
    
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func next<C: Collection>(in collection: C, from index: C.Index) -> C.Index? where C.Element == Element {
        collection[index...].firstIndex(where: options.relevant)
    }
    
    // MARK: Algorithms
    
    /// - Complexity: O(n), where n is the length of the collection (lhs).
    @usableFromInline func prefix() -> LHS.SubSequence {
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
        
        return lhs[...currentLHS]
    }
    
    /// - Complexity: O(n), where n is the length of the collection (lhs).
    @inlinable func suffix() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        typealias RL = ReversedCollection<LHS>
        typealias RR = ReversedCollection<RHS>
        typealias RS = Similarites<Element, RL, RR>
        
        let reversed = RS(in: lhs.reversed(), and: rhs.reversed(), with: options).prefix()
        
        return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
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
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func prefix(alsoIn other: Self, options: SimilaritiesOptions<Element>) -> SubSequence {
        Similarites(in: self, and: other, with: options).prefix()
    }
}

// MARK: - Suffix

extension BidirectionalCollection where Element: Equatable {
    /// - Complexity: O(n), where n is the length of the collection.
    @inlinable func suffix(alsoIn other: Self, options: SimilaritiesOptions<Element>) -> SubSequence {
        Similarites(in: self, and: other, with: options).suffix()
    }
}
