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
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: Pattern
    @usableFromInline var placeholders: [Character: (Character) -> Bool]
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

    @inlinable public func placeholder(_ character: Character, where predicate: @escaping (Character) -> Bool = { _ in true }) -> Self {
        var result = self; result.placeholders[character] = predicate; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Upstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Output
    //=------------------------------------------------------------------------=
    
    @inlinable public func upstream(value: Value, mode: Mode) -> Output<Value> {
        var content = Value()
        var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Indices, Iterators
        //=--------------------------------------=
        var queueIndex = pattern.startIndex
        var patternIndex = pattern.startIndex
        var valueIterator = value.makeIterator()
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        body: while patternIndex != pattern.endIndex {
            let character = pattern[patternIndex]
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                //=------------------------------=
                // MARK: Next
                //=------------------------------=
                if let next = valueIterator.next(), predicate(next) {
                    content.append(next)
                    snapshot += Snapshot(pattern[queueIndex..<patternIndex], as: .phantom)
                    snapshot.append(Symbol(next, as: .content))
                    pattern.formIndex(after: &patternIndex)
                    queueIndex = patternIndex
                //=------------------------------=
                // MARK: None
                //=------------------------------=
                } else if value.isEmpty {
                    snapshot += Snapshot(pattern[queueIndex..<patternIndex], as: .phantom)
                    snapshot.append(.anchor)
                    queueIndex = patternIndex
                    break body
                //=------------------------------=
                // MARK: Last
                //=------------------------------=
                } else { break body }
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            } else {
                pattern.formIndex(after: &patternIndex)
            }
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        visible ? snapshot += Snapshot(pattern[queueIndex...], as: .phantom) : ()
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Output(value: content, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Downstream
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Output
    //=------------------------------------------------------------------------=
    
    @inlinable public func downstream(snapshot: Snapshot, input: Input) throws -> Output<Value> {
        //=--------------------------------------=
        // MARK: Proposal
        //=--------------------------------------=
        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: input.content)
        //=--------------------------------------=
        // MARK: Value, Output
        //=--------------------------------------=
        return try upstream(value: parse(snapshot: proposal), mode: .editable)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        var nonvirtuals = snapshot.lazy.filter(\.nonvirtual).makeIterator()
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        var value = Value()
        //=--------------------------------------=
        // MARK: Pattern
        //=--------------------------------------=
        loop: for character in pattern {
            //=----------------------------------=
            // MARK: Placeholder
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard let next = nonvirtuals.next() else { break loop }
                //=------------------------------=
                // MARK: Predicate
                //=------------------------------=
                guard predicate(next.character) else {
                    throw Info([.mark(next.character), "is invalid."])
                }
                //=------------------------------=
                // MARK: Insertion
                //=------------------------------=
                value.append(next.character)
            }
        }
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        guard nonvirtuals.next() == nil else {
            throw Info([.mark(snapshot.characters), "exceeded pattern capacity."])
        }
        //=--------------------------------------=
        // MARK: Success
        //=--------------------------------------=
        return value
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

extension PatternTextStyle: UIKitDiffableTextStyle { }

#endif
