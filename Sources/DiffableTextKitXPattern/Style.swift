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

public struct PatternTextStyle<Value>: DiffableTextStyle where Value: Equatable,
Value: RangeReplaceableCollection, Value.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: String
    @usableFromInline var placeholders = Placeholders()
    @usableFromInline var hidden = false
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ pattern: String) {
        self.pattern = pattern
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func placeholders(_ character: Character,
    where predicate: @escaping (Character) -> Bool) -> Self {
        var result = self; result.placeholders = .init((character, predicate)); return result
    }
    
    @inlinable public func placeholders(_ placeholders: [Character: (Character) -> Bool]) -> Self {
        var result = self; result.placeholders = .init(placeholders); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Hides the pattern suffix.
    @inlinable public func hidden(_ hidden: Bool = true) -> Self {
        var result = self; result.hidden = hidden; return result
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
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        reduce(with: value, into: String()) {
            characters, virtuals, nonvirtual in
            characters.append(contentsOf: virtuals)
            characters.append(nonvirtual)
        } none: {
            characters, virtuals in
            characters.append(contentsOf: virtuals)
        } done: {
            characters, virtuals, mismatches in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if !hidden {
                characters.append(contentsOf: virtuals)
            }
            //=----------------------------------=
            // Mismatches
            //=----------------------------------=
            if !mismatches.isEmpty {
                characters.append("|")
                characters.append(contentsOf: mismatches)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are removed.
    @inlinable public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        reduce(with: value, into: Commit()) {
            commit, virtuals, nonvirtual in
            commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            commit.snapshot.append(nonvirtual)
            commit.value   .append(nonvirtual)
        } none: {
            commit, virtuals in
            commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            commit.snapshot.anchorAtEndIndex()
        } done: {
            commit, virtuals, mismatches in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if !hidden {
                commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            }
            //=----------------------------------=
            // Mismatches
            //=----------------------------------=
            if !mismatches.isEmpty {
                Brrr.autocorrection << Info([.mark(value), "has invalid suffix \(mismatches)"])
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches throw an error.
    @inlinable @inline(never) public func resolve(_ proposal:
    Proposal, with cache: inout Void) throws -> Commit<Value> {
        var value = Value(); let proposal = proposal.merged()
        var nonvirtuals = proposal.nonvirtuals.makeIterator()
        //=--------------------------------------=
        // Parse
        //=--------------------------------------=
        parse: for character in pattern {
            if let predicate = placeholders[character] {
                guard let nonvirtual = nonvirtuals.next() else { break parse }
                //=------------------------------=
                // Predicate
                //=------------------------------=
                guard predicate(nonvirtual) else {
                    throw Info([.mark(nonvirtual), "is invalid"])
                }
                //=------------------------------=
                // Insertion
                //=------------------------------=
                value.append(nonvirtual)
            }
        }
        //=--------------------------------------=
        // Capacity
        //=--------------------------------------=
        guard nonvirtuals.next() == nil else {
            throw Info([.mark(proposal.characters), "exceeded pattern capacity \(value.count)"])
        }
        //=--------------------------------------=
        // Interpret
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
    
    @inlinable @inline(never) func reduce<Result>(
    with value:  Value,
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
        var qIndex = pIndex // position
        //=--------------------------------------=
        // Matches
        //=--------------------------------------=
        matches: while qIndex != pattern.endIndex {
            //=----------------------------------=
            // Placeholder
            //=----------------------------------=
            if let predicate = placeholders[pattern[qIndex]] {
                guard vIndex != value.endIndex else { break matches }
                let nonvirtual = value[vIndex]
                guard    predicate(nonvirtual) else { break matches }
                //=------------------------------=
                // (!) Some
                //=------------------------------=
                some(&result, pattern[pIndex ..< qIndex], nonvirtual)
                value  .formIndex(after: &vIndex)
                pattern.formIndex(after: &qIndex)
                pIndex = qIndex
            //=----------------------------------=
            // Miscellaneous
            //=----------------------------------=
            } else {
                pattern.formIndex(after: &qIndex)
            }
        }
        //=--------------------------------------=
        // (!) None
        //=--------------------------------------=
        if  pIndex == pattern.startIndex {
            none(&result, pattern[pIndex ..< qIndex])
            pIndex = qIndex
        }
        //=--------------------------------------=
        // (!) Done
        //=--------------------------------------=
        done(&result, pattern[pIndex...], value[vIndex...]); return result
    }
}
