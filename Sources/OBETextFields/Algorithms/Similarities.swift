//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Similarites<Collection: Swift.Collection> where Collection.Element: Equatable {
    @usableFromInline typealias Index = Collection.Index
    @usableFromInline typealias Element = Collection.Element
    
    // MARK: Properties
    
    @usableFromInline let lhs: Collection
    @usableFromInline let rhs: Collection
    @usableFromInline let options: SimilaritiesOptions<Element>
    
    // MARK: Initializers
    
    @inlinable init(in lhs: Collection, alsoIn rhs: Collection, options: SimilaritiesOptions<Element>) {
        self.lhs = lhs
        self.rhs = rhs
        self.options = options
    }
    
    // MARK: Helpers
    
    
    /// - Complexity: O(collection.count).
    @inlinable func next(in collection: Collection, from index: Index) -> Index? {
        collection[index...].firstIndex(where: options.evaluated)
    }
    
    // MARK: Algorithms
    
    /// - Complexity: O(lhs.count).
    @usableFromInline func prefix() -> Collection.SubSequence {
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
    
    /// - Complexity: O(min(lhs.count, rhs.count)).
    @inlinable func suffix() -> Collection.SubSequence where Collection: BidirectionalCollection {
        typealias Reversed = ReversedCollection<Collection>
        
        let reversed = Similarites<Reversed>(in: lhs.reversed(), alsoIn: rhs.reversed(), options: options).prefix()
        
        return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
}

// MARK: -

@usableFromInline struct SimilaritiesOptions<Element> {
    @usableFromInline let evaluated: (Element) -> Bool
    @usableFromInline let overshoot: Bool
    
    @inlinable init(evaluated: @escaping (Element) -> Bool, overshoot: Bool) {
        self.evaluated = evaluated
        self.overshoot = overshoot
    }
    
    @inlinable static var normal: Self {
        Self(evaluated: { _ in true }, overshoot: false)
    }
    
    @inlinable static func overshoot(_ evaluated: @escaping (Element) -> Bool) -> Self {
        Self(evaluated: evaluated, overshoot: false)
    }
    
    @inlinable static func wrap(_ evaluated: @escaping (Element) -> Bool) -> Self {
        Self(evaluated: evaluated, overshoot: false)
    }
}

// MARK: - Prefix

extension Collection where Element: Equatable {
    @inlinable func prefix(alsoIn other: Self, options: SimilaritiesOptions<Element>) -> SubSequence {
        Similarites(in: self, alsoIn: other, options: options).prefix()
    }
}

// MARK: - Suffix

extension BidirectionalCollection where Element: Equatable {
    @inlinable func suffix(alsoIn other: Self, options: SimilaritiesOptions<Element>) -> SubSequence {
        Similarites(in: self, alsoIn: other, options: options).suffix()
    }
}
