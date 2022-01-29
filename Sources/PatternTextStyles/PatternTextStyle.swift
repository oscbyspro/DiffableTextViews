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
    
    /// Matches the value against the pattern to form a collection of characters.
    @inlinable public func showcase(value: Value) -> String {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    /// Matches the value agains the pattern into a commit.
    ///
    /// - Mismatches are cut.
    ///
    @inlinable public func editable(value: Value) -> Commit<Value> {
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
                //=------------------------------=
                // MARK: Next
                //=------------------------------=
                if let content = valueIterator.next() {
                    guard predicate.check(content) else { break loop }
                    contents.append(content)
                    snapshot.append(contentsOf: Snapshot(pattern[queueIndex..<patternIndex], as: .phantom))
                    snapshot.append(Symbol(content, as: .content))
                    pattern.formIndex(after: &patternIndex); queueIndex = patternIndex
                    continue loop
                //=------------------------------=
                // MARK: None
                //=------------------------------=
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
            throw Info([.mark(request.proposal().characters), "exceeded pattern capacity."])
        }
        //=--------------------------------------=
        // MARK: Value -> Commit
        //=--------------------------------------=
        return editable(value: value)
    }
}
