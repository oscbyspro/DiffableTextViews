//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews

//*============================================================================*
// MARK: * PatternTextStyle
//*============================================================================*

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    @usableFromInline typealias Predicates = PatternTextStyles.Predicates<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: Pattern
    @usableFromInline let placeholder: Character
    @usableFromInline var predicates: Predicates
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(pattern: Pattern, placeholder: Character) {
        self.pattern = pattern
        self.placeholder = placeholder
        self.predicates = Predicates()
        self.visible = true
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func hidden() -> Self {
        var result = self
        result.visible = false
        return result
    }
    
    @inlinable public func assert(_ predicate: Predicate<Value>) -> Self {
        var result = self
        result.predicates.add(predicate)
        return result
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate<C: Collection>(_ characters: C) throws where C.Element == Character {
        let capacity = pattern.reduce(into: 0) { $0 += $1 == placeholder ? 1 : 0 }
        
        guard characters.count <= capacity else {
            throw Info([.mark(characters), "exceeded pattern capacity", .mark(capacity)])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - UIKitDiffableTextStyle
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension PatternTextStyle: UIKitDiffableTextStyle { }

#endif

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Parse
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = Value(snapshot.lazy.filter({ !$0.contains(.virtual) }).map(\.character))
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        try validate(value)
        try predicates.validate(value)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return value
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(value: Value, mode: Mode) -> Snapshot {
        var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var valueIndex = value.startIndex
        var patternIndex = pattern.startIndex
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        while patternIndex != pattern.endIndex, valueIndex != value.endIndex {
            //=----------------------------------=
            // MARK: Element
            //=----------------------------------=
            let patternElement = pattern[patternIndex]
            pattern.formIndex(after: &patternIndex)
            //=----------------------------------=
            // MARK: Match, Insert
            //=----------------------------------=
            if patternElement == placeholder {
                let valueElement = value[valueIndex]
                value.formIndex(after: &valueIndex)
                snapshot.append(Symbol(valueElement, as: .content))
            } else {
                snapshot.append(Symbol(patternElement, as: .phantom))
            }
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        if visible {
            //=----------------------------------=
            // MARK: Head
            //=----------------------------------=
            if valueIndex == value.startIndex, let anchorIndex = pattern[patternIndex...].firstIndex(where: { $0 == placeholder }) {
                snapshot.append(contentsOf: Snapshot(pattern[patternIndex..<anchorIndex], as: .phantom))
                snapshot.append(.anchor)
                patternIndex = anchorIndex
            }
            //=----------------------------------=
            // MARK: Tail
            //=----------------------------------=
            snapshot.append(contentsOf: Snapshot(pattern[patternIndex...], as: .phantom))
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Merge
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value> {
        //=--------------------------------------=
        // MARK: Proposal
        //=--------------------------------------=
        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: input.content)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try parse(snapshot: proposal)
        //=--------------------------------------=
        // MARK: Snapshot, Output
        //=--------------------------------------=
        return Output<Value>(self.snapshot(value: value, mode: .editable), value: value)
    }
}
