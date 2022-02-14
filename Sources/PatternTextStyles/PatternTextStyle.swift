//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * PatternTextStyle
//*============================================================================*

public struct PatternTextStyle<Value>: DiffableTextStyle where
Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: String
    @usableFromInline var placeholders: [Character: Predicate]
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ pattern: String) {
        self.pattern = pattern
        self.placeholders = [:]
        self.visible = true
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Hides the pattern suffix.
    @inlinable public func hidden(_ hidden: Bool = true) -> Self {
        var result = self; result.visible = !hidden; return result
    }

    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.pattern      == rhs.pattern      else { return false }
        guard lhs.placeholders == rhs.placeholders else { return false }
        guard lhs.visible      == rhs.visible      else { return false }
        return true
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are separated.
    @inlinable public func format(value: Value) -> String {
        var characters = String()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        iterate(value) { queue, content in
            characters.append(contentsOf: queue)
            characters.append(content)
        } none: { queue in
            characters.append(contentsOf: queue)
        } remainders: { queue, contents in
            visible ? characters += queue : ()
            guard !contents.isEmpty else { return }
            characters.append("|")
            characters.append(contentsOf: contents)
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return characters
    }

    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are cut.
    @inlinable public func interpret(value: Value) -> Commit<Value> {
        var elements = Value(); var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        iterate(value) { queue, content in
            elements.append(content)
            snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            snapshot.append(Symbol(content, as: .content))
        } none: { queue in
            snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            snapshot.append(.anchor)
        } remainders: { queue, _ in
            visible ? snapshot += Snapshot(queue, as: .phantom) : ()
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Commit(value: elements, snapshot: snapshot)
    }

    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func iterate(_ value: Value, some: (Substring, Character) -> Void,
        none: (Substring) -> Void, remainders: (Substring, Value.SubSequence) -> Void) {
        var vIndex = value.startIndex
        var pIndex = pattern.startIndex
        var qIndex = pIndex // queue
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: while pIndex != pattern.endIndex {
            let character = pattern[pIndex]
            //=----------------------------------=
            // MARK: Value
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard vIndex != value.endIndex else { break loop }
                let   content = value[vIndex]
                guard predicate.check(content) else { break loop }
                //=------------------------------=
                // MARK: Some
                //=------------------------------=
                some(pattern[qIndex..<pIndex], content)
                value.formIndex(after: &vIndex)
                pattern.formIndex(after: &pIndex)
                qIndex = pIndex
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else { pattern.formIndex(after: &pIndex) }
        }
        //=----------------------------------=
        // MARK: None
        //=----------------------------------=
        if qIndex == pattern.startIndex {
            none(pattern[qIndex..<pIndex])
            qIndex = pIndex
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        remainders(pattern[qIndex...], value[vIndex...])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    /// - Mismatches throw an error.
    @inlinable public func merge(changes: Changes) throws -> Commit<Value> {
        var value = Value()
        let proposal = changes.proposal()
        var contents = proposal.lazy.filter(\.nonvirtual).makeIterator()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        for character in pattern {
            guard let predicate = placeholders[character] else { continue }
            guard let content = contents.next() else { break }
            //=----------------------------------=
            // MARK: Check
            //=----------------------------------=
            guard predicate.check(content.character) else {
                throw Info([.mark(content.character), "is invalid"])
            }
            //=----------------------------------=
            // MARK: Value
            //=----------------------------------=
            value.append(content.character)
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        guard contents.next() == nil else {
            throw Info([.mark(proposal.characters), "exceeded pattern capacity."])
        }
        //=--------------------------------------=
        // MARK: Value -> Commit
        //=--------------------------------------=
        return interpret(value: value)
    }
}
