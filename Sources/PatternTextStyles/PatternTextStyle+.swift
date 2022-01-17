//
//  PatternTextStyle+.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Parse
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = Value(snapshot.lazy.filter({ !$0.contains(.virtual) }).map(\.character))
        //=--------------------------------------=
        // MARK: Validate
        //=--------------------------------------=
        try validate(value)
        try predicates.validate(value)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return value
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(value: Value, mode: Mode) -> Snapshot {
        var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var vIndex =   value.startIndex
        var patternIndex = pattern.startIndex
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        while patternIndex != pattern.endIndex, vIndex != value.endIndex {
            //=----------------------------------=
            // MARK: Element
            //=----------------------------------=
            let patternElement = pattern[patternIndex]
            pattern.formIndex(after:    &patternIndex)
            //=----------------------------------=
            // MARK: Match, Insert
            //=----------------------------------=
            if patternElement == placeholder {
                let valueElement = value[vIndex]
                value.formIndex(after:   &vIndex)
                snapshot.append(Symbol(valueElement, as: .content))
            } else {
                snapshot.append(Symbol(patternElement, as: .phantom))
            }
        }
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        if visible {
            //=----------------------------------=
            // MARK: Head
            //=----------------------------------=
            if vIndex == value.startIndex, let anchorIndex = pattern[patternIndex...].firstIndex(where: { $0 == placeholder }) {
                snapshot.append(contentsOf: Snapshot(pattern[patternIndex..<anchorIndex], as: .phantom))
                snapshot.append(.anchor)
                patternIndex = anchorIndex
            }
            //=----------------------------------=
            // MARK: Tail
            //=----------------------------------=
            snapshot.append(contentsOf: Snapshot(pattern[patternIndex...], as: .phantom))
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Merge
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with input: Input) throws -> Output<Value> {
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
        // MARK: Snapshot
        //=--------------------------------------=
        let snapshot = self.snapshot(value: value, mode: .editable)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Output<Value>(snapshot, value: value)
    }
}
