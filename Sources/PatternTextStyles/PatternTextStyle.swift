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
    
    /// Hides the pattern characters that suffixes the last value character.
    ///
    /// - If you want the entire pattern to be invisible, use spaces instead.
    ///
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
        var _value = value.makeIterator()
        loop: for character in pattern {
            //=----------------------------------=
            // MARK: Predicate
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard let real = _value.next() else { return }
                try predicate.validate(real)
            }
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        guard _value.next() == nil else {
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
        var (_value,   _pattern) = (value.makeIterator(), pattern.makeIterator())
        //=--------------------------------------------------------------------=
        // MARK: Head
        //=--------------------------------------------------------------------=
        head: while let character = _pattern.next() {
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if placeholders.contains(character) {
                if let real = _value.next() {
                    snapshot.append(Symbol(real, as: .content))
                } else {
                    snapshot.append(.anchor)
                    phantoms.append(character)
                }
                
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
                if let real = _value.next() {
                    snapshot.append(contentsOf: Snapshot(phantoms, as: .phantom))
                    snapshot.append(Symbol(real, as: .content))
                    phantoms.removeAll(keepingCapacity: true)
                } else {
                    phantoms.append(character)
                    break body
                }
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
            snapshot.append(contentsOf: Snapshot(phantoms, as: .phantom))
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
