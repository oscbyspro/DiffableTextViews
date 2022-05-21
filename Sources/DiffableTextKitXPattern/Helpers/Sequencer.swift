//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequencer
//*============================================================================*

@usableFromInline struct Sequencer<Value: Collection> where Value.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: String
    @usableFromInline let placeholders: [Character: Predicate]
    @usableFromInline let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ pattern: String, _ placeholders: [Character: Predicate], _ value: Value) {
        self.pattern = pattern
        self.placeholders = placeholders
        self.value = value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func reduce<Result>(into result: Result,
    some: (inout Result, Substring, Character) -> Void,
    none: (inout Result, Substring) -> Void,
    done: (inout Result, Substring, Value.SubSequence) -> Void) -> Result {
        //=--------------------------------------=
        // Variables
        //=--------------------------------------=
        var result = result
        var vIndex = value.startIndex
        var pIndex = pattern.startIndex
        var qIndex = pIndex // queue
        //=--------------------------------------=
        // Loop
        //=--------------------------------------=
        loop: while pIndex != pattern.endIndex {
            let character = pattern[pIndex]
            //=----------------------------------=
            // Value
            //=----------------------------------=
            if let predicate = placeholders[character] {
                guard vIndex != value.endIndex else { break loop }
                let   content = value[vIndex]
                guard predicate.check(content) else { break loop }
                //=------------------------------=
                // Some
                //=------------------------------=
                some(&result, pattern[qIndex..<pIndex], content)
                value.formIndex(after: &vIndex)
                pattern.formIndex(after: &pIndex)
                qIndex = pIndex
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            } else { pattern.formIndex(after: &pIndex) }
        }
        //=----------------------------------=
        // None
        //=----------------------------------=
        if qIndex == pattern.startIndex {
            none(&result, pattern[qIndex..<pIndex])
            qIndex = pIndex
        }
        //=--------------------------------------=
        // Done
        //=--------------------------------------=
        done(&result, pattern[qIndex...], value[vIndex...]); return result
    }
}
