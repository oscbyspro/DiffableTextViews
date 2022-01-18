//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * PatternTextStyle
//*============================================================================*

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: Pattern
    @usableFromInline var placeholders: Placeholders
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(pattern: Pattern) {
        self.pattern = pattern
        self.placeholders = Placeholders()
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Placeholder
    //=------------------------------------------------------------------------=
    
    @inlinable public func placeholder(_ character: Character, where predicate: Predicate) -> Self {
        var result = self
        result.placeholders.insert(character, where: predicate)
        return result
    }
    
    @inlinable public func placeholder(_ character: Character, where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate([predicate]))
    }
            
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate<C: Collection>(_ characters: C) throws where C.Element == Character {
        let capacity = pattern.count(where: placeholders.contains)
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
        #warning("Should not validate value.")
        try placeholders.validate(value)
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
            if let _ = placeholders[patternElement] {
                snapshot.append(.content(value[valueIndex]))
                value.formIndex(after: &valueIndex)
            } else {
                snapshot.append(.phantom(patternElement))
            }
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        if visible {
            //=----------------------------------=
            // MARK: Head
            //=----------------------------------=
            while patternIndex != pattern.endIndex {
                let patternElement = pattern[patternIndex]
                if let _ = placeholders[patternElement] { break }
                snapshot.append(.phantom(patternElement))
                pattern.formIndex(after: &patternIndex)
            }
            //=----------------------------------=
            // MARK: Anchor
            //=----------------------------------=
            if valueIndex == value.startIndex {
                snapshot.append(.anchor)
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
