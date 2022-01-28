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

#warning("Untested.")
#warning("Undocumented.")
public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle where
Pattern: Collection, Pattern.Element == Character,
Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    @usableFromInline typealias Predicate = (Character) -> Bool
    
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

    @inlinable public func placeholder(_ placeholder: Character,
        where predicate: @escaping (Character) -> Bool = { _ in true }) -> Self {
        var result = self; result.placeholders[placeholder] = predicate; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Upstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable public func showcase(value: Value) -> String {
        var characters = String()
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var valueIndex = value.startIndex
        var patternIndex = pattern.startIndex
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        loop: while patternIndex != pattern.endIndex {
            let character = pattern[patternIndex]
            //=--------------------------------------=
            // MARK: Placeholder
            //=--------------------------------------=
            if let predicate = placeholders[character] {
                guard valueIndex != value.endIndex else { break loop }
                let real = value[valueIndex]; guard predicate(real) else { break loop }
                characters.append(real); value.formIndex(after: &valueIndex)
            //=--------------------------------------=
            // MARK: Pattern
            //=--------------------------------------=
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
        // MARK: Remainders - Value
        //=--------------------------------------=
        if valueIndex != value.endIndex {
            characters.append("|")
            characters.append(contentsOf: value[valueIndex...])
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return characters
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func editable(value: Value) -> Commit<Value> {
        var content = Value()
        var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Indices, Iterators
        //=--------------------------------------=
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
                if let real = valueIterator.next(), predicate(real) {
                    content.append(real)
                    snapshot += Snapshot(pattern[queueIndex..<patternIndex], as: .phantom)
                    snapshot.append(Symbol(real, as: .content))
                    pattern.formIndex(after: &patternIndex)
                    queueIndex = patternIndex
                //=------------------------------=
                // MARK: None
                //=------------------------------=
                } else if value.isEmpty {
                    snapshot += Snapshot(pattern[queueIndex..<patternIndex], as: .phantom)
                    snapshot.append(.anchor)
                    queueIndex = patternIndex
                    break loop
                //=------------------------------=
                // MARK: Last
                //=------------------------------=
                } else { break loop }
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                pattern.formIndex(after: &patternIndex)
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
                guard let real = nonvirtuals.next() else { break loop }
                //=------------------------------=
                // MARK: Predicate
                //=------------------------------=
                guard predicate(real.character) else {
                    throw Info([.mark(real.character), "is invalid."])
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

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension PatternTextStyle: UIKitDiffableTextStyle { }

#endif
