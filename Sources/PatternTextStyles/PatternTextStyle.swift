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
        Sequencer(pattern, placeholders, value).reduce(into: .init()) {
            characters, queue, content in
            characters.append(contentsOf: queue)
            characters.append(content)
        } none: {
            characters, queue in
            characters.append(contentsOf: queue)
        } remainders: {
            characters, queue, contents in
            visible ? characters += queue : ()
            guard !contents.isEmpty else { return }
            characters.append("|")
            characters.append(contentsOf: contents)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Commit
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are cut.
    @inlinable public func interpret(value: Value) -> Commit<Value> {
        Sequencer(pattern, placeholders, value).reduce(into: .init()) {
            commit, queue, content in
            commit.value.append(content)
            commit.snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            commit.snapshot.append(Symbol(content, as: .content))
        } none: {
            commit, queue in
            commit.snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            commit.snapshot.append(.anchor)
        } remainders: {
            commit, queue, _ in
            visible ? commit.snapshot += Snapshot(queue, as: .phantom) : ()
        }
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
            guard predicate.check(content.character) else {
                throw Info([.mark(content.character), "is invalid"])
            }
            //=----------------------------------=
            // MARK: Insert
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
