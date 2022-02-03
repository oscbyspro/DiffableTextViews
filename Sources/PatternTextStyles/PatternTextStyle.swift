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
    @inlinable public func hidden() -> Self {
        var result = self; result.visible = false; return result
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
// MARK: PatternTextStyle - Format
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    /// Matches the value against the pattern to form a collection of characters.
    ///
    /// - Mismatches are hidden.
    ///
    @inlinable public func format(value: Value) -> String {
        var characters = String()
        var patternIndex = pattern.startIndex
        var valueIterator = value.makeIterator()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: while patternIndex != pattern.endIndex {
            let character = pattern[patternIndex]
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard let content = valueIterator.next(), predicate.check(content) else { break loop }
                characters.append(content)
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                characters.append(character)
            }
            
            pattern.formIndex(after: &patternIndex)
        }
        //=--------------------------------------=
        // MARK: Remainders - Pattern
        //=--------------------------------------=
        visible ? characters.append(contentsOf: pattern[patternIndex...]) : ()
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return characters
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Commit
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    /// Matches the value agains the pattern to form a commit.
    ///
    /// - Mismatches are cut.
    ///
    @inlinable public func commit(value: Value) -> Commit<Value> {
        var contents = Value()
        var snapshot = Snapshot()
        var queueIndex = pattern.startIndex
        var patternIndex = pattern.startIndex
        var valueIterator = value.makeIterator()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: while patternIndex != pattern.endIndex {
            let character = pattern[patternIndex]
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                if let content = valueIterator.next() {
                    guard predicate.check(content) else { break loop }
                    contents.append(content)
                    snapshot.append(contentsOf: Snapshot(pattern[queueIndex..<patternIndex], as: .phantom))
                    snapshot.append(Symbol(content, as: .content))
                    pattern.formIndex(after: &patternIndex); queueIndex = patternIndex
                    continue loop
                } else if contents.isEmpty {
                    snapshot.append(contentsOf: Snapshot(pattern[queueIndex..<patternIndex], as: .phantom))
                    snapshot.append(.anchor)
                    queueIndex = patternIndex
                }
                
                break loop
            }
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            pattern.formIndex(after: &patternIndex)
        }
        //=--------------------------------------=
        // MARK: Remainders - Pattern
        //=--------------------------------------=
        visible ? snapshot += Snapshot(pattern[queueIndex...], as: .phantom) : ()
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Commit(value: contents, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Merge
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Marges, parses and matches the request to form a commit.
    ///
    /// - Mismatches throw an error.
    ///
    @inlinable public func merge(changes: Changes) throws -> Commit<Value> {
        var value = Value(); var nonvirtuals = changes.proposal().lazy.filter(\.nonvirtual).makeIterator()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: for character in pattern {
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard let nonvirtual = nonvirtuals.next() else { break loop }
                guard predicate.check(nonvirtual.character) else {
                    throw Info([.mark(nonvirtual.character), "is invalid"])
                }

                value.append(nonvirtual.character)
            }
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        guard nonvirtuals.next() == nil else {
            throw Info([.mark(changes.proposal().characters), "exceeded pattern capacity."])
        }
        //=--------------------------------------=
        // MARK: Value -> Commit
        //=--------------------------------------=
        return commit(value: value)
    }
}
