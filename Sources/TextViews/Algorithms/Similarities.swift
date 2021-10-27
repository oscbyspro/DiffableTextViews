//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

import Foundation

// MARK: - Similarities

@usableFromInline struct Similarities<LHS: Collection, RHS: Collection> where LHS.Element == RHS.Element {
    @usableFromInline typealias Element = LHS.Element
    @usableFromInline typealias Options = SimilaritiesOptions<Element>
    @usableFromInline typealias Instruction = SimilaritiesInstruction
    
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
    
    // MARK: Transformations
    
    @inlinable func make<L: Collection, R: Collection>(_ lhs: L, _ rhs: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: lhs, and: rhs, with: options)
    }
    
    @inlinable func swap() -> Similarities<RHS, LHS> {
        make(rhs, lhs)
    }

    @inlinable func reverse() -> Similarities<ReversedCollection<LHS>, ReversedCollection<RHS>> where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        make(lhs.reversed(), rhs.reversed())
    }
    
    // MARK: Calculations
    
    @inlinable func prefixIndices() -> Indices {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        
        // --------------------------------- //
        
        loop: while let nextLHSIndex = lhs[lhsIndex...].firstIndex(where: options.inspection.includes),
                    let nextRHSIndex = rhs[rhsIndex...].firstIndex(where: options.inspection.includes) {
            
            // --------------------------------- //
            
            let instruction = options.comparison.instruction(lhs[nextLHSIndex], rhs[nextRHSIndex])

            // --------------------------------- //
                        
            if instruction == .done {
                break loop
            }
            
            if instruction.contains(.continueOnLHS) {
                lhsIndex = lhs.index(after: nextLHSIndex)
            }
            
            if instruction.contains(.continueOnRHS) {
                rhsIndex = rhs.index(after: nextRHSIndex)
            }
        }
        
        // --------------------------------- //
        
        if options.production == .overshoot {
            lhsIndex = lhs[lhsIndex...].firstIndex(where: options.inspection.includes) ?? lhs.endIndex
            rhsIndex = rhs[rhsIndex...].firstIndex(where: options.inspection.includes) ?? rhs.endIndex
        }
        
        // --------------------------------- //
        
        return Indices(lhsIndex, rhsIndex)
    }

    // MARK: Utilities
    
    @inlinable func lhsPrefix() -> LHS.SubSequence {
        lhs.prefix(upTo: prefixIndices().lhs)
    }
    
    @inlinable func rhsPrefix() -> RHS.SubSequence {
        rhs.prefix(upTo: prefixIndices().rhs)
    }
    
    @inlinable func lhsSuffix() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = reverse().lhsPrefix(); return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    @inlinable func rhsSuffix() -> RHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = reverse().rhsPrefix(); return rhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    // MARK: Components: Indices
    
    @usableFromInline struct Indices {
        
        // MARK: Properties
        
        @usableFromInline var lhs: LHS.Index
        @usableFromInline var rhs: RHS.Index
        
        // MARK: Initializers
        
        @inlinable init(_ lhs: LHS.Index, _ rhs: RHS.Index) {
            self.lhs = lhs
            self.rhs = rhs
        }
    }
}

// MARK: - Comparison

@usableFromInline struct SimilaritiesInstruction: OptionSet {
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8 = 0) {
        self.rawValue = rawValue
    }
    
    // MARK: Options

    @usableFromInline static let continueOnLHS = Self(rawValue: 1 << 0)
    @usableFromInline static let continueOnRHS = Self(rawValue: 1 << 1)
    
    // MARK: Composites
    
    @usableFromInline static let `continue` = Self([.continueOnLHS, .continueOnRHS])
    @usableFromInline static let     `done` = Self([])
}
            
// MARK: - Collection

extension Collection {
    
    // MARK: Prefix
    
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).lhsPrefix()
    }

    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).lhsPrefix()
    }
}

// MARK: - BidirectionalCollection
            
extension BidirectionalCollection {
    
    // MARK: Suffix
    
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(lhs: self, rhs: other, options: options).lhsSuffix()
    }

    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(lhs: self, rhs: other, options: options).lhsSuffix()
    }
}

// MARK: -

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
    
    @inlinable func compare(_ newValue: Comparison) -> Self {
        update({ $0.comparison = newValue })
    }
        
    @inlinable func inspect(_ newValue: Inspection) -> Self {
        update({ $0.inspection = newValue })
    }
    
    @inlinable func produce(_ newValue: Production) -> Self {
        update({ $0.production = newValue })
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func update(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: - Options: Comparison

@usableFromInline struct SimilaritiesOptionsComparison<Element> {
    @usableFromInline typealias Instruction = SimilaritiesInstruction
    
    // MARK: Properties
    
    @usableFromInline let instruction: (Element, Element) -> Instruction
    
    // MARK: Initializers
    
    @inlinable init(_ instruction: @escaping (Element, Element) -> Instruction) {
        self.instruction = instruction
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func instruction(_ instruction: @escaping (Element, Element) -> Instruction) -> Self {
        Self(instruction)
    }
    
    @inlinable static func equation(_ equivalent: @escaping (Element, Element) -> Bool) -> Self {
        Self({ equivalent($0, $1) ? .`continue` : .`done` })
    }
    
    @inlinable static func equatable<Value: Equatable>(_ value: @escaping (Element) -> Value) -> Self {
        Self({ value($0) == value($1) ? .`continue` : .`done` })
    }
}


// MARK: - Options: Inspection

@usableFromInline struct SimilaritiesOptionsInspection<Element> {
    @usableFromInline let includes: (Element) -> Bool
    
    // MARK: Initializers
    
    @inlinable init(includes: @escaping (Element) -> Bool) {
        self.includes = includes
    }
    
    // MARK: Initializers: Static

    @inlinable static var each: Self {
        Self(includes: { _ in true })
    }
    
    @inlinable static func only(_ includes: @escaping (Element) -> Bool) -> Self {
        Self(includes: includes)
    }

    @inlinable static var defaultValue: Self { .each }
}

// MARK: - Options: Production

@usableFromInline enum SimilaritiesOptionsProduction {
    case wrapper
    case overshoot
    
    // MARK: Initializers: Static
    
    @inlinable static var defaultValue: Self { .wrapper }
}
