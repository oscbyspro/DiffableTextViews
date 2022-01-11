//
//  PatternTextStyle+.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        var snapshot = Snapshot()
        var valueIndex = value.startIndex
        var patternIndex = format.pattern.startIndex
        
        //=--------------------------------------=
        // MARK: Prefix Up To First Placeholder
        //=--------------------------------------=
        
        while patternIndex != format.pattern.endIndex {
            let patternElement =  format.pattern[patternIndex]
            if  patternElement == format.placeholder { break }

            snapshot.append(.prefix(patternElement))
            format.pattern.formIndex(after: &patternIndex)
        }
        
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        
        while patternIndex != format.pattern.endIndex, valueIndex != value.endIndex {
            let patternElement = format.pattern[patternIndex]
            format.pattern.formIndex(after:    &patternIndex)
            
            if patternElement == format.placeholder {
                let valueElement = value[valueIndex]
                value.formIndex(after:  &valueIndex)
                snapshot.append(.content(valueElement))
            } else {
                snapshot.append(.spacer(patternElement))
            }
        }
        
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        
        if visible, patternIndex != format.pattern.endIndex {
            snapshot.append(contentsOf: Snapshot(String(format.pattern[patternIndex...]), only: .suffix))
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
    
    @inlinable public func merge(snapshot: Snapshot, with input: Input) throws -> Snapshot {
        
        //=--------------------------------------=
        // MARK: Proposal
        //=--------------------------------------=
        
        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: input.content)
        
        //=--------------------------------------=
        // MARK: Value, Continue
        //=--------------------------------------=
        
        return try self.snapshot(editable: parse(snapshot: proposal))
    }
}

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
        
        let value = Value(snapshot
            .lazy
            .filter({ !$0.attribute.contains(.formatting) })
            .map(\.character))
                          
        //=--------------------------------------=
        // MARK: Validation
        //=--------------------------------------=
        
        try format.validate(value)
        try predicates.validate(value)
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return value
    }
}

