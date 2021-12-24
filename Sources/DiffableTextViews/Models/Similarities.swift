//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

import protocol Utilities.Transformable

// MARK: - Similarities

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
    
    // MARK: Getters
    
    @inlinable func inspectable(_ element: Element) -> Bool {
        options.inspection.includes(element)
    }

    @inlinable func instruction(_ lhs: LHS.Element, _ rhs: RHS.Element) -> SimilaritiesInstruction {
        options.comparison.instruction(lhs, rhs)
    }

    // MARK: Transformations

    @inlinable func reversed() -> Similarities<ReversedCollection<LHS>, ReversedCollection<RHS>> where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        .init(lhs: lhs.reversed(), rhs: rhs.reversed(), options: options)
    }

    // MARK: Utilities
    
    @inlinable func lhsPrefix() -> LHS.SubSequence {
        lhs.prefix(upTo: prefixEndIndices().lhs)
    }
    
    @inlinable func rhsPrefix() -> RHS.SubSequence {
        rhs.prefix(upTo: prefixEndIndices().rhs)
    }
    
    @inlinable func lhsSuffix() -> LHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = reversed().lhsPrefix(); return lhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    @inlinable func rhsSuffix() -> RHS.SubSequence where LHS: BidirectionalCollection, RHS: BidirectionalCollection {
        let reversed = reversed().rhsPrefix(); return rhs[reversed.endIndex.base ..< reversed.startIndex.base]
    }
    
    // MARK: Utilities: Helpers
    
    @inlinable func prefixEndIndices() -> (lhs: LHS.Index, rhs: RHS.Index) {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        
        // --------------------------------- //
        
        while let nextLHSIndex = lhs[lhsIndex...].firstIndex(where: inspectable),
              let nextRHSIndex = rhs[rhsIndex...].firstIndex(where: inspectable) {
            
            // --------------------------------- //
            
            let instruction = instruction(lhs[nextLHSIndex], rhs[nextRHSIndex])

            // --------------------------------- //
            
            if instruction.isEmpty {
                break
            }
            
            if instruction.contains(.continueOnLHS) {
                lhsIndex = lhs.index(after: nextLHSIndex)
            }
            
            if instruction.contains(.continueOnRHS) {
                rhsIndex = rhs.index(after: nextRHSIndex)
            }
        }
        
        // --------------------------------- //
        
        lhsIndex = lhs[lhsIndex...].firstIndex(where: inspectable) ?? lhs.endIndex
        rhsIndex = rhs[rhsIndex...].firstIndex(where: inspectable) ?? rhs.endIndex
        
        // --------------------------------- //
        
        return (lhs: lhsIndex, rhs: rhsIndex)
    }
}

// MARK: - Instruction

@usableFromInline struct SimilaritiesInstruction: OptionSet {
    
    // MARK: Properties
    
    @usableFromInline let rawValue: UInt8
    
    // MARK: Initializers
    
    @inlinable init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    // MARK: Instances: Singular

    @usableFromInline static let continueOnLHS = Self(rawValue: 1 << 0)
    @usableFromInline static let continueOnRHS = Self(rawValue: 1 << 1)
    
    // MARK: Instances: Composites
    
    @usableFromInline static let `none`     = Self()
    @usableFromInline static let `continue` = Self([.continueOnLHS, .continueOnRHS])
}

// MARK: - Comparison

@usableFromInline struct SimilaritiesComparison<Element> {
    @usableFromInline typealias Instruction = SimilaritiesInstruction
    
    // MARK: Properties
    
    @usableFromInline let instruction: (Element, Element) -> Instruction
    
    // MARK: Initializers
    
    @inlinable init(instruction: @escaping (Element, Element) -> Instruction) {
        self.instruction = instruction
    }
    
    // MARK: Initializers: Static
    
    @inlinable static func equation(_ equivalent: @escaping (Element, Element) -> Bool) -> Self {
        .init(instruction: { equivalent($0, $1) ? .continue : .none })
    }
    
    @inlinable static func equatable<Value: Equatable>(_ value: @escaping (Element) -> Value) -> Self {
        .init(instruction: { value($0) == value($1) ? .continue : .none })
    }
    
    @inlinable static func instruction(_ instruction: @escaping (Element, Element) -> Instruction) -> Self {
        .init(instruction: instruction)
    }
}

// MARK: - Inspection

@usableFromInline struct SimilaritiesInspection<Element> {
    
    // MARK: Properties
    
    @usableFromInline let includes: (Element) -> Bool
    
    // MARK: Initializers
    
    @inlinable init(includes: @escaping (Element) -> Bool) {
        self.includes = includes
    }
    
    // MARK: Initializers: Static

    @inlinable static var all: Self {
        .init(includes: { _ in true })
    }
    
    @inlinable static func only(_ includes: @escaping (Element) -> Bool) -> Self {
        .init(includes: includes)
    }
}

// MARK: - Options

@usableFromInline struct SimilaritiesOptions<Element>: Transformable {
    @usableFromInline typealias Comparison = SimilaritiesComparison<Element>
    @usableFromInline typealias Inspection = SimilaritiesInspection<Element>
    
    // MARK: Properties

    @usableFromInline var comparison: Comparison
    @usableFromInline var inspection: Inspection

    // MARK: Initializers

    @inlinable init(comparison: Comparison, inspection: Inspection = .all) {
        self.comparison = comparison
        self.inspection = inspection
    }
    
    @inlinable init(inspection: Inspection = .all) where Element: Equatable {
        self.comparison = Comparison.equation(==)
        self.inspection = inspection
    }
}
