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
// MARK: * Style
//*============================================================================*

public struct PatternTextStyle<Value>: DiffableTextStyle where
Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    @usableFromInline typealias Placeholders = [Character: Predicate]

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: String
    @usableFromInline var placeholders: Placeholders
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
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are separated.
    @inlinable public func format(_ value: Value) -> String {
        reduce(value, into: String()) {
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
        reduce(value, into: Commit()) {
            commit, queue, content in
            commit.snapshot.append(contentsOf: queue, as: .phantom)
            commit.snapshot.append(content)
            commit.value   .append(content)
        } none: {
            commit, queue in
            commit.snapshot.append(contentsOf: queue, as: .phantom)
            commit.snapshot.anchorAtEndIndex()
        } done: {
            commit, queue, _ in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if visible {
                commit.snapshot.append(contentsOf: queue, as: .phantom)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches throw an error.
    @inlinable @inline(never) public func resolve(_ proposal: Proposal) throws -> Commit<Value> {
        var value = Value(); let proposal = proposal.merged()
        var nonvirtuals = proposal.lazy.filter(\.nonvirtual).makeIterator()
        //=--------------------------------------=
        // Parse
        //=--------------------------------------=
        parse: for character in pattern {
            if let predicate = placeholders[character] {
                guard let nonvirtual = nonvirtuals.next() else { break parse }
                //=------------------------------=
                // Predicate
                //=------------------------------=
                guard predicate.check(nonvirtual.character) else {
                    throw Info([.mark(nonvirtual.character), "is invalid"])
                }
                //=------------------------------=
                // Insertion
                //=------------------------------=
                value.append(nonvirtual.character)
            }
        }
        //=--------------------------------------=
        // Capacity
        //=--------------------------------------=
        guard nonvirtuals.next() == nil else {
            throw Info([.mark(proposal.characters), "exceeded pattern capacity", .note(value.count)])
        }
        //=--------------------------------------=
        // Value -> Commit
        //=--------------------------------------=
        return interpret(value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Reduce
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(never) func reduce<Result>(_ value: Value,
    into result: Result,
    some: (inout Result, Substring, Character) -> Void,
    none: (inout Result, Substring) -> Void,
    done: (inout Result, Substring, Value.SubSequence) -> Void) -> Result {
        //=--------------------------------------=
        // State
        //=--------------------------------------=
        var result = result
        var vIndex = value  .startIndex
        var pIndex = pattern.startIndex
        var qIndex = pIndex // queue
        //=--------------------------------------=
        // Pattern
        //=--------------------------------------=
        body: while pIndex != pattern.endIndex {
            let character   = pattern[pIndex]
            //=----------------------------------=
            // Placeholder
            //=----------------------------------=
            if let predicate  = placeholders[character] {
                guard vIndex != value.endIndex else { break body }
                let   content = value[vIndex]
                //=------------------------------=
                // Predicate
                //=------------------------------=
                guard predicate.check(content) else { break body }
                //=------------------------------=
                // (!) Some
                //=------------------------------=
                some(&result, pattern[qIndex ..< pIndex], content)
                value  .formIndex(after: &vIndex)
                pattern.formIndex(after: &pIndex)
                qIndex = pIndex
            //=----------------------------------=
            // Miscellaneous
            //=----------------------------------=
            } else {
                pattern.formIndex(after: &pIndex)
            }
        }
        //=--------------------------------------=
        // (!) None
        //=--------------------------------------=
        if qIndex == pattern.startIndex {
            none(&result, pattern[qIndex ..< pIndex])
            qIndex = pIndex
        }
        //=--------------------------------------=
        // (!) Done
        //=--------------------------------------=
        done(&result, pattern[qIndex...], value[vIndex...]); return result
    }
}
