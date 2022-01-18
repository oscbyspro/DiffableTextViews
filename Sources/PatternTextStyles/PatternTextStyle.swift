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

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle where
Pattern: Collection, Pattern.Element == Character,
Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    
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
    
    @inlinable public func placeholder(_ character: Character, where predicate: (Character) -> Bool...) -> Self {
        placeholder(character, where: Predicate(predicate))
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - UIKit
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
        // MARK: Characters
        //=--------------------------------------=
        let characters = snapshot
            .lazy
            .filter({ !$0.contains(.virtual) })
            .map(\.character)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = Value(characters)
        //=--------------------------------------=
        // MARK: Validation
        //=--------------------------------------=
        try validate(value: value)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(value: Value) throws {
        var position = value.startIndex
        //=--------------------------------------=
        // MARK: Loop Through Pattern
        //=--------------------------------------=
        for character in pattern {
            if let predicate = placeholders[character] {
                //=------------------------------=
                // MARK: Index
                //=------------------------------=
                if position == value.endIndex { return }
                defer { value.formIndex(after: &position) }
                //=------------------------------=
                // MARK: Character
                //=------------------------------=
                try predicate.validate(value[position])
            }
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        guard position == value.endIndex else {
            throw Info([.mark(value), "exceeded pattern capacity."])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    #warning("Hmm, maybe this should be throwable.")
    @inlinable public func snapshot(value: Value, mode: Mode = .editable) -> Snapshot {
        var (snapshot, phantoms) = (Snapshot(), String())
        var (_value, _pattern) = (value.startIndex, pattern.makeIterator())
        //=--------------------------------------------------------------------=
        // MARK: Helpers
        //=--------------------------------------------------------------------=
        func snapshotValue() {
            snapshot.append(Symbol(value[_value], as: .content))
            value.formIndex(after:      &_value)
        }
        //=--------------------------------------------------------------------=
        // MARK: Head
        //=--------------------------------------------------------------------=
        head: while let character = _pattern.next() {
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if placeholders.contains(character) {
                _value != value.endIndex ? snapshotValue() : snapshot.append(.anchor)
                break head
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                snapshot.append(Symbol(character, as: .phantom))
            }
        }
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        body: while let character = _pattern.next() {
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if placeholders.contains(character) {
                guard _value != value.endIndex else { break body }

                snapshot.append(contentsOf: Snapshot(phantoms, as: .phantom))
                phantoms.removeAll(keepingCapacity: true)

                snapshotValue()
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                phantoms.append(character)
            }
        }
        //=--------------------------------------------------------------------=
        // MARK: Tail
        //=--------------------------------------------------------------------=
        tail: if visible {
            while let character = _pattern.next() {
                snapshot.append(Symbol(character, as: .phantom))
            }
        }
        //=--------------------------------------------------------------------=
        // MARK: Done
        //=--------------------------------------------------------------------=
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
        return Output<Value>(self.snapshot(value: value), value: value)
    }
}
