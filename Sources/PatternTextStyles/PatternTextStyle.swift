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

#warning("Determine a predictable behavior for invalid values.")
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

    @inlinable public func placeholder(_ character: Character,
        where predicate: @escaping (Character) -> Bool = { _ in true }) -> Self {
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
    
    #error("Continue.")
    #warning("This method should also perform validation.")
    @inlinable public func upstream(value: Value, mode: Mode = .editable) -> Output<Value> {
        var content = Value()
        var snapshot = Snapshot()
        var position = pattern.startIndex
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
                    snapshot += Snapshot(pattern[position..<patternIndex], as: .phantom)
                    snapshot.append(Symbol(next, as: .content))
                    pattern.formIndex(after: &patternIndex)
                    position = patternIndex
                //=------------------------------=
                // MARK: None
                //=------------------------------=
                } else if value.isEmpty {
                    snapshot += Snapshot(pattern[position..<patternIndex], as: .phantom)
                    snapshot.append(.anchor)
                    position = patternIndex
                    break body
                //=------------------------------=
                // MARK: Last
                //=------------------------------=
                } else { break body }
            }
            //=----------------------------------=
            // MARK: Pattern
            //=----------------------------------=
            pattern.formIndex(after: &patternIndex)
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        visible ? snapshot += Snapshot(pattern[position...], as: .phantom) : ()
        
        if mode == .showcase {
            while let next = valueIterator.next() {
                snapshot.
            }
        }
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Output(content, snapshot: snapshot)
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
        // MARK: Value
        //=--------------------------------------=
        let value = try parse(snapshot: proposal)
        //=--------------------------------------=
        // MARK: Snapshot, Output
        //=--------------------------------------=
        return Output(value, snapshot: self.snapshot(value: value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    #warning("...")
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
                guard let real = nonvirtuals.next() else { break loop }
                guard predicate(real.character) else {
                    throw Info([.mark(real.character), "is invalid."])
                }
                
                value.append(real.character)
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
