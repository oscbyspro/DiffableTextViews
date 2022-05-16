//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: Declaration
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.pattern == rhs.pattern
        && lhs.placeholders == rhs.placeholders
        && lhs.visible == rhs.visible
    }
}

//=----------------------------------------------------------------------------=
// MARK: Utilities
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are separated.
    @inlinable public func format(_ value: Value) -> String {
        Sequencer(pattern, placeholders, value).reduce(into: .init()) {
            characters, queue, content in
            characters.append(contentsOf: queue)
            characters.append(content)
        } none: {
            characters, queue in
            characters.append(contentsOf: queue)
        } done: {
            characters, queue, contents in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if visible {
                characters.append(contentsOf: queue)
            }
            //=----------------------------------=
            // Mismatches
            //=----------------------------------=
            if !contents.isEmpty {
                characters.append("|")
                characters.append(contentsOf: contents)
            }
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are cut.
    @inlinable public func interpret(_ value: Value) -> Commit<Value> {
        Sequencer(pattern, placeholders, value).reduce(into: .init()) {
            commit, queue, content in
            commit.snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            commit.snapshot.append(Symbol(content, as: .content))
            commit.value.append(content)
        } none: {
            commit, queue in
            commit.snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            commit.snapshot.anchorAtEndIndex()
        } done: {
            commit, queue, _ in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if visible {
                commit.snapshot.append(contentsOf: Snapshot(queue, as: .phantom))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches throw an error, which results in user input cancellation.
    @inlinable public func merge(_ proposal: Proposal) throws -> Commit<Value> {
        var value = Value(); let proposal = proposal.merged()
        var contents = proposal.lazy.filter(\.nonvirtual).makeIterator()
        //=--------------------------------------=
        // Parse
        //=--------------------------------------=
        parse: for character in pattern {
            if let predicate = placeholders[character] {
                guard let content = contents.next() else { break parse }
                guard predicate.check(content.character) else {
                    throw Info([.mark(content.character), "is invalid"])
                }
                //=------------------------------=
                // Some
                //=------------------------------=
                value.append(content.character)
            }
        }
        //=--------------------------------------=
        // Capacity
        //=--------------------------------------=
        guard contents.next() == nil else {
            throw Info([.mark(proposal.characters), "exceeded pattern capacity", .note(value.count)])
        }
        //=--------------------------------------=
        // Value -> Commit
        //=--------------------------------------=
        return interpret(value)
    }
}
