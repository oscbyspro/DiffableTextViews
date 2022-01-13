//
//  Changes.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

//*============================================================================*
// MARK: * Changes
//*============================================================================*

@usableFromInline struct Changes<Elements: BidirectionalCollection> where Elements.Element == Symbol {
    @usableFromInline typealias Reversed = ReversedCollection<Elements>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let past: Elements
    @usableFromInline let next: Elements
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(from past: Elements, to next: Elements) {
        self.past = past
        self.next = next
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func reversed() -> Changes<Reversed> {
        Changes<Reversed>(from: past.reversed(), to: next.reversed())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - Start
    //=------------------------------------------------------------------------=
    
    @inlinable func start() -> (past: Elements.Index, next: Elements.Index) {
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var pastIndex = past.startIndex
        var nextIndex = next.startIndex
        //=--------------------------------------=
        // MARK: Elements
        //=--------------------------------------=
        var pastElement = past[pastIndex]
        var nextElement = next[nextIndex]
        //=----------------------------------=
        // MARK: Loop
        //=----------------------------------=
        while pastIndex != past.endIndex,
              nextIndex != next.endIndex {
            //=------------------------------=
            // MARK: Indices, Elements
            //=------------------------------=
            if pastElement == nextElement {
                past.formIndex(after: &pastIndex)
                pastElement = past[pastIndex]
                next.formIndex(after: &nextIndex)
                nextElement = next[nextIndex]
            } else if pastElement.removable {
                past.formIndex(after: &pastIndex)
                pastElement = past[pastIndex]
            } else if nextElement.insertable {
                next.formIndex(after: &nextIndex)
                nextElement = next[nextIndex]
            } else {
                break
            }
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return (pastIndex, nextIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities - End
    //=------------------------------------------------------------------------=
    
    @inlinable func end() -> (past: Elements.Index, next: Elements.Index) {
        let reversed = self.reversed().start(); return (reversed.past.base, reversed.next.base)
    }
}
