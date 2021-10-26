//
//  Similarities.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: - Similarities

#warning("Make common method for primaryPrefix and secondaryPrefix.")
@usableFromInline struct Similarities<Primary: Collection, Secondary: Collection> where Primary.Element == Secondary.Element {
    @usableFromInline typealias Element = Primary.Element
    @usableFromInline typealias Options = SimilaritiesOptions<Element>
    @usableFromInline typealias Instruction = SimilaritiesInstruction
    @usableFromInline typealias Reversed<T: BidirectionalCollection> = ReversedCollection<T>
    
    // MARK: Properties
    
    @usableFromInline let primary: Primary
    @usableFromInline let secondary: Secondary
    @usableFromInline let options: Options
    
    // MARK: Initializers
    
    @inlinable init(primary: Primary, secondary: Secondary, options: Options) {
        self.primary = primary
        self.secondary = secondary
        self.options = options
    }
    
    @inlinable init(in primary: Primary, and secondary: Secondary, with options: Options) {
        self.init(primary: primary, secondary: secondary, options: options)
    }
    
    @inlinable init(in primary: Primary, and secondary: Secondary, with options: Options = .defaults()) where Element: Equatable {
        self.init(primary: primary, secondary: secondary, options: options)
    }
    
    // MARK: Transformations
    
    @inlinable func make<L: Collection, R: Collection>(_ primary: L, _ secondary: R) -> Similarities<L, R> where L.Element == Element {
        Similarities<L, R>(in: primary, and: secondary, with: options)
    }
    
    @inlinable func swap() -> Similarities<Secondary, Primary> {
        make(secondary, primary)
    }

    @inlinable func reverse() -> Similarities<Reversed<Primary>, Reversed<Secondary>> where Primary: BidirectionalCollection, Secondary: BidirectionalCollection {
        make(primary.reversed(), secondary.reversed())
    }
    
    // MARK: Methods
    
    @usableFromInline func prefix() -> Primary.SubSequence {
        var primaryIndex = primary.startIndex
        var secondaryIndex = secondary.startIndex
        
        // --------------------------------- //
        
        print()

        
        while let nextPrimaryIndex = primary[primaryIndex...].firstIndex(where: options.inspection.includes),
              let nextSecondaryIndex = secondary[secondaryIndex...].firstIndex(where: options.inspection.includes) {
            
            // --------------------------------- //
            
            let instruction = options.comparison.instruction(primary[nextPrimaryIndex], secondary[nextSecondaryIndex])

            // --------------------------------- //
            
            print(primary[nextPrimaryIndex], secondary[nextSecondaryIndex], instruction.rawValue)
            print("primary: \(instruction.contains(.continueInPrimary)), secondary: \(instruction.contains(.continueInSecondary))")
            
            guard !instruction.isEmpty else { break }
            
            // --------------------------------- //
                        
            if instruction.contains(.continueInPrimary) {

                primaryIndex = primary.index(after: nextPrimaryIndex)
            }
            
            if instruction.contains(.continueInSecondary) {
                secondaryIndex = secondary.index(after: nextSecondaryIndex)
            }
        }
        
        // --------------------------------- //
        
        if options.production == .overshoot {
            primaryIndex = primary[primaryIndex...].firstIndex(where: options.inspection.includes) ?? primary.endIndex
        }
        
        // --------------------------------- //
        
        return primary[..<primaryIndex]
    }
    
    @inlinable func suffix() -> Primary.SubSequence where Primary: BidirectionalCollection, Secondary: BidirectionalCollection {
        let reversed = make(primary.reversed(), secondary.reversed()).prefix()
        return primary[reversed.endIndex.base ..< reversed.startIndex.base]
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

    @usableFromInline static let continueInPrimary   = Self(rawValue: 1 << 0)
    @usableFromInline static let continueInSecondary = Self(rawValue: 1 << 1)
    
    // MARK: Composites
    
    @usableFromInline static let `continue` = Self([.continueInPrimary, .continueInSecondary])
    @usableFromInline static let `done`     = Self([])
}
            
// MARK: - Collection

extension Collection {
    
    // MARK: Prefix
    
    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(primary: self, secondary: other, options: options).prefix()
    }

    @inlinable func prefix<Other: Collection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(primary: self, secondary: other, options: options).prefix()
    }
}

// MARK: - BidirectionalCollection
            
extension BidirectionalCollection {
    
    // MARK: Suffix
    
    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options) -> SubSequence where Other.Element == Element {
        Similarities(primary: self, secondary: other, options: options).suffix()
    }

    @inlinable func suffix<Other: BidirectionalCollection>(alsoIn other: Other, options: Similarities<Self, Other>.Options = .defaults()) -> SubSequence where Other.Element == Element, Element: Equatable {
        Similarities(primary: self, secondary: other, options: options).suffix()
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
    
    @inlinable func compare(_ comparison: Comparison) -> Self {
        copy(assign: comparison, to: \.comparison)
    }
        
    @inlinable func inspect(_ inspection: Inspection) -> Self {
        copy(assign: inspection, to: \.inspection)
    }
    
    @inlinable func produce(_ production: Production) -> Self {
        copy(assign: production, to: \.production)
    }
    
    // MARK: Transformations: Helpers
    
    @inlinable func copy<Value>(assign newValue: Value, to keyPath: WritableKeyPath<Self, Value>) -> Self {
        var copy = self; copy[keyPath: keyPath] = newValue; return copy
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
        Self({ equivalent($0, $1) ? .continue : .done })
    }
    
    @inlinable static func equatable<Value: Equatable>(_ value: @escaping (Element) -> Value) -> Self {
        Self({ value($0) == value($1) ? .continue : .done })
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
