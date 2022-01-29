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
Pattern: Collection, Pattern: Equatable, Pattern.Element == Character,
Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: Pattern
    @usableFromInline var placeholders: [Character: Predicate]
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ pattern: Pattern) {
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
    // MARK: Transformations - Placeholder
    //=------------------------------------------------------------------------=
    
    @inlinable public func placeholder(_ placeholder: Character, where predicate: Predicate = .constant()) -> Self {
        var result = self; result.placeholders[placeholder] = predicate; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.pattern == rhs.pattern else { return false }
        guard lhs.placeholders == rhs.placeholders else { return false }
        guard lhs.visible == rhs.visible else { return false }
        return true
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension PatternTextStyle: UIKitDiffableTextStyle { }

#endif

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Upstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    /// Matches the value agains the pattern into a collection of characters.
    ///
    /// - Format: matches + | + mismatches.
    ///
    @inlinable public func showcase(value: Value) -> String {
        var characters = String()
        //=--------------------------------------=
        // MARK: Indices, Iterators
        //=--------------------------------------=
        var index = pattern.startIndex
        var valueIterator = value.makeIterator()
        var next = valueIterator.next()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: while index != pattern.endIndex {
            let character = pattern[index]
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard let real = next, predicate.check(real) else { break loop }
                //=------------------------------=
                // MARK: Insertion
                //=------------------------------=
                characters.append(real)
                next = valueIterator.next()
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                //=------------------------------=
                // MARK: Insertion
                //=------------------------------=
                characters.append(character)
            }
            //=----------------------------------=
            // MARK: Iteration
            //=----------------------------------=
            pattern.formIndex(after: &index)
        }
        //=--------------------------------------=
        // MARK: Remainders - Pattern
        //=--------------------------------------=
        visible ? characters.append(contentsOf: pattern[index...]) : ()
        //=--------------------------------------=
        // MARK: Remainders - Value
        //=--------------------------------------=
        if let remainder = next {
            characters.append("|")
            characters.append(remainder)
            while let real = valueIterator.next() { characters.append(real) }
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return characters
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    /// Matches the value agains the pattern into a commit.
    ///
    /// - Mismatches are cut.
    ///
    @inlinable public func editable(value: Value) -> Commit<Value> {
        var content = Value()
        var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Indices, Iterators
        //=--------------------------------------=
        var index = pattern.startIndex
        var queueIndex = pattern.startIndex
        var valueIterator = value.makeIterator()
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: while index != pattern.endIndex {
            let character = pattern[index]
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                //=------------------------------=
                // MARK: Next
                //=------------------------------=
                if let real = valueIterator.next() {
                    guard predicate.check(real) else { break loop }
                    //=------------------------------=
                    // MARK: Insertion, Iteration
                    //=------------------------------=
                    content.append(real)
                    snapshot += Snapshot(pattern[queueIndex..<index], as: .phantom)
                    snapshot.append(Symbol(real, as: .content))
                    pattern.formIndex(after: &index)
                    queueIndex = index
                //=------------------------------=
                // MARK: None
                //=------------------------------=
                } else if value.isEmpty {
                    //=------------------------------=
                    // MARK: Insertion
                    //=------------------------------=
                    snapshot += Snapshot(pattern[queueIndex..<index], as: .phantom)
                    snapshot.append(.anchor)
                    queueIndex = index
                    break loop
                //=------------------------------=
                // MARK: Last
                //=------------------------------=
                } else { break loop }
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                //=------------------------------=
                // MARK: Iteration
                //=------------------------------=
                pattern.formIndex(after: &index)
            }
        }
        //=--------------------------------------=
        // MARK: Remainders - Pattern
        //=--------------------------------------=
        visible ? snapshot += Snapshot(pattern[queueIndex...], as: .phantom) : ()
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Commit(value: content, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Downstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    /// Marges, parses and matches the request into a commit.
    ///
    /// - Mismatches throw an error.
    ///
    @inlinable public func merge(request: Request) throws -> Commit<Value> {
        var value = Value(); var nonvirtuals = request.proposal().lazy.filter(\.nonvirtual).makeIterator()
        //=--------------------------------------=
        // MARK: Parse
        //=--------------------------------------=
        loop: for character in pattern {
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard let real = nonvirtuals.next() else { break loop }
                //=------------------------------=
                // MARK: Predicate
                //=------------------------------=
                guard predicate.check(real.character) else {
                    throw Info([.mark(real.character), "is invalid"])
                }
                //=------------------------------=
                // MARK: Insertion
                //=------------------------------=
                value.append(real.character)
            }
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        guard nonvirtuals.next() == nil else {
            throw Info([.mark(request.proposal().characters), "exceeded pattern capacity."])
        }
        //=--------------------------------------=
        // MARK: Value -> Commit
        //=--------------------------------------=
        return editable(value: value)
    }
}
