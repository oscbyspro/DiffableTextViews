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
    
    @inlinable init(in lhs: LHS, and rhs: RHS, with options: Options = .defaults()) where Element: Equatable {
        self.init(lhs: lhs, rhs: rhs, options: options)
    }
    
    // MARK: Maps
    
    @inlinable func make<L: Collection, R: Collection>(_ lhs: L, _ rhs: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: lhs, and: rhs, with: options)
    }
    
    // MARK: Helpers
    
    @inlinable func firstInspectableIndex<C: Collection>(in collection: C, from index: C.Index) -> C.Index? where C.Element == Element {
        collection[index...].firstIndex(where: options.inspection.includes)
    }
    
    // MARK: Methods
    
    @usableFromInline func lhsPrefix() -> LHS.SubSequence {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        
        while lhsIndex < lhs.endIndex, rhsIndex < rhs.endIndex {
            guard let lhsInspectableIndex = firstInspectableIndex(in: lhs, from: lhsIndex) else { break }
            guard let rhsInspectableIndex = firstInspectableIndex(in: rhs, from: rhsIndex) else { break }

            guard options.comparison.equivalent(lhs[lhsInspectableIndex], rhs[rhsInspectableIndex]) else { break }

            lhsIndex = lhs.index(after: lhsNextIndex)
            rhsIndex = rhs.index(after: rhsInspectableIndex)
        }
        
        if options.production == .overshoot {
            lhsIndex = firstInspectableIndex(in: lhs, from: lhsIndex) ?? lhs.endIndex
        }
        
        return lhs[..<lhsIndex]
    }
    
    @inlinable func rhsPrefix() -> RHS.SubSequence {
        make(rhs, lhs).lhsPrefix()
    }
    
    @inlinable func lhsSuffix() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = make(lhs.reversed(), rhs.reversed()).lhsPrefix()
        return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    @inlinable func rhsSuffix() -> RHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        make(rhs, lhs).lhsSuffix()
    }
}

// MARK: - Prefix

extension Collection {
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).lhsPrefix()
    }

    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).lhsPrefix()
    }
}

// MARK: - Suffix

extension BidirectionalCollection {
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).lhsSuffix()
    }

    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).lhsSuffix()
    }
}

// MARK: - Similarities: Components

@usableFromInline struct SimilaritiesOptions<Element> {
    @usableFromInline typealias Comparison = SimilaritiesOptionsComparison<Element>
    @usableFromInline typealias Inspection = SimilaritiesOptionsInspection<Element>
    @usableFromInline typealias Production = SimilaritiesOptionsProduction
    
    // MARK: Storage
    
    @usableFromInline var comparison: Comparison
    @usableFromInline var inspection: Inspection
    @usableFromInline var production: Production

    // MARK: Initializers

    @inlinable init(comparison: Comparison, inspection: Inspection = .defaultValue, production: Production = .defaultValue) {
        self.comparison = comparison
        self.inspection = inspection
        self.production = production
    }
    
    @inlinable init(comparison: Comparison = .equation(==), inspection: Inspection = .defaultValue, production: Production = .defaultValue) where Element: Equatable {
        self.comparison = comparison
        self.inspection = inspection
        self.production = production
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func compare(_ comparison: Comparison) -> Self {
        Self(comparison: comparison)
    }
    
    @inlinable static func inspect(_ inspection: Inspection) -> Self where Element: Equatable {
        Self(inspection: inspection)
    }

    @inlinable static func produce(_ production: Production) -> Self where Element: Equatable {
        Self(production: production)
    }
    
    @inlinable static func defaults() -> Self where Element: Equatable {
        Self(comparison: .equation(==))
    }
    
    // MARK: Transformations
    
    @inlinable func compare(_ comparison: Comparison) -> Self {
        assign(value: comparison, to: \.comparison)
    }
        
    @inlinable func inspect(_ inspection: Inspection) -> Self {
        assign(value: inspection, to: \.inspection)
    }
    
    @inlinable func produce(_ production: Production) -> Self {
        assign(value: production, to: \.production)
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func assign<Value>(value newValue: Value, to keyPath: WritableKeyPath<Self, Value>) -> Self {
        var copy = self; copy[keyPath: keyPath] = newValue; return copy
    }
}

// MARK: - SimilaritiesOptions: Comparison

@usableFromInline struct SimilaritiesOptionsComparison<Element> {
    @usableFromInline let equivalent: (Element, Element) -> Bool
    
    // MARK: Initializers
    
    @inlinable init(equivalent: @escaping (Element, Element) -> Bool) {
        self.equivalent = equivalent
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func equation(_ equivalent: @escaping (Element, Element) -> Bool) -> Self {
        Self(equivalent: equivalent)
    }
    
    @inlinable static func equatable<Value: Equatable>(_ value: @escaping (Element) -> Value) -> Self {
        Self(equivalent: { value($0) == value($1) })
    }
}

// MARK: - SimilaritiesOptions: Inspection

@usableFromInline struct SimilaritiesOptionsInspection<Element> {
    @usableFromInline let includes: (Element) -> Bool
    
    // MARK: Initializers
    
    @inlinable init(includes: @escaping (Element) -> Bool) {
        self.includes = includes
    }
    
    // MARK: Initializers: Static

    @inlinable static var each: Self {
        Self(includes: { element in true })
    }
    
    @inlinable static func only(where includes: @escaping (Element) -> Bool) -> Self {
        Self(includes: includes)
    }
    
    @inlinable static var defaultValue: Self { .each }
}

// MARK: - SimilaritiesOptions: Production

@usableFromInline enum SimilaritiesOptionsProduction {
    case wrap
    case overshoot
    
    // MARK: Initializers: Static
    
    @inlinable static var defaultValue: Self { .wrap }
}
