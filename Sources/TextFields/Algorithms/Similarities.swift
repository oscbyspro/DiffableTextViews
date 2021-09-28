//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

@usableFromInline struct Similarities<LHS: Collection, RHS: Collection> where LHS.Element == RHS.Element {
    @usableFromInline typealias Element = LHS.Element
    @usableFromInline typealias Options = SimilaritiesOptions<Element>
    
    // MARK: Properties
    
    @usableFromInline let lhs: LHS
    @usableFromInline let rhs: RHS
    @usableFromInline let options: Options
    
    // MARK: Initializers
    
    @inlinable init(lhs: LHS, rhs: RHS, options: Options) {
        self.lhs = lhs
        self.rhs = rhs
        self.options = options
    }
    
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options) {
        self.init(lhs: lhs, rhs: rhs, options: options)
    }
    
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options = .equate(==)) where Element: Equatable {
        self.init(lhs: lhs, rhs: rhs, options: options)
    }
    
    // MARK: Maps
    
    @inlinable func make<L: Collection, R: Collection>(_ lhs: L, _ rhs: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: lhs, and: rhs, with: options)
    }
    
    // MARK: Helpers
    
    @inlinable func next<C: Collection>(in collection: C, from index: C.Index) -> C.Index? where C.Element == Element {
        collection[index...].firstIndex(where: options.relevant)
    }

    // MARK: Methods
    
    @usableFromInline func prefixLHS() -> LHS.SubSequence {
        var currentLHS = lhs.startIndex
        var currentRHS = rhs.startIndex

        while currentLHS < lhs.endIndex, currentRHS < rhs.endIndex {
            guard let nextLHS = next(in: lhs, from: currentLHS) else { break }
            guard let nextRHS = next(in: rhs, from: currentRHS) else { break }

            guard options.equivalent(lhs[nextLHS], rhs[nextRHS]) else { break }

            currentLHS = lhs.index(after: nextLHS)
            currentRHS = rhs.index(after: nextRHS)
        }

        if options.overshoot, currentLHS < lhs.endIndex {
            currentLHS = next(in: lhs, from: currentLHS) ?? lhs.endIndex
        }

        return lhs[..<currentLHS]
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

@usableFromInline struct SimilaritiesOptions<Element> {
    @usableFromInline var equivalent: (Element, Element) -> Bool
    @usableFromInline var relevant: (Element) -> Bool
    @usableFromInline var overshoot: Bool

    // MARK: Initializers
    
    @inlinable init(equivalent: @escaping (Element, Element) -> Bool, relevant: ((Element) -> Bool)? = nil, overshoot: Bool? = nil) {
        self.equivalent = equivalent
        self.relevant = relevant ?? { _ in true }
        self.overshoot = overshoot ?? false
    }

    @inlinable init(equate equivalent: @escaping (Element, Element) -> Bool, evaluate relevant: ((Element) -> Bool)? = nil, overshoot: Bool? = nil) {
        self.init(equivalent: equivalent, relevant: relevant, overshoot: overshoot)
    }
    
    @inlinable init(equate equivalent: @escaping (Element, Element) -> Bool = { $0 == $1 }, evaluate relevant: ((Element) -> Bool)? = nil, overshoot: Bool? = nil) where Element: Equatable {
        self.init(equivalent: equivalent, relevant: relevant, overshoot: overshoot)
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func equate(_ equivalent: @escaping (Element, Element) -> Bool) -> Self {
        Self(equate: equivalent)
    }
    
    @inlinable static func evaluate(only relevant: @escaping (Element) -> Bool) -> Self where Element: Equatable {
        Self(evaluate: relevant)
    }

    @inlinable static func overshoot(_ overshoot: Bool = true) -> Self where Element: Equatable {
        Self(overshoot: overshoot)
    }
    
    // MARK: Transformations
    
    @inlinable func equate(_ equivalent: @escaping (Element, Element) -> Bool) -> Self {
        assign(value: equivalent, to: \.equivalent)
    }
        
    @inlinable func evaluate(only relevant: @escaping (Element) -> Bool) -> Self {
        assign(value: relevant, to: \.relevant)
    }
    
    @inlinable func overshoot(_ overshoot: Bool = true) -> Self {
        assign(value: overshoot, to: \.overshoot)
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func assign<Value>(value newValue: Value, to keyPath: WritableKeyPath<Self, Value>) -> Self {
        var copy = self; copy[keyPath: keyPath] = newValue; return copy
    }
}

// MARK: - Prefix

extension Collection {
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).prefixLHS()
    }

    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .equate(==)) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).prefixLHS()
    }
}

// MARK: - Suffix

extension BidirectionalCollection {
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).suffixLHS()
    }

    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .equate(==)) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).suffixLHS()
    }
}
