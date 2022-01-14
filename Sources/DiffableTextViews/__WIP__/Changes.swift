//
//  Changes.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

//*============================================================================*
// MARK: * Changes
//*============================================================================*

@usableFromInline enum Changes<Past, Next> where
Past: BidirectionalCollection, Past.Element == Symbol,
Next: BidirectionalCollection, Next.Element == Symbol {
    @usableFromInline typealias Reversed = Changes<ReversedCollection<Past>, ReversedCollection<Next>>

    //=------------------------------------------------------------------------=
    // MARK: Start
    //=------------------------------------------------------------------------=
    
    @inlinable static func start(past: Past, next: Next) -> (past: Past.Index, next: Next.Index) {
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var pastIndex = past.startIndex
        var nextIndex = next.startIndex
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        if pastIndex != past.endIndex,
           nextIndex != next.endIndex {
            //=----------------------------------=
            // MARK: Elements
            //=----------------------------------=
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
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return (pastIndex, nextIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: End
    //=------------------------------------------------------------------------=
    
    @inlinable static func end(past: Past, next: Next) -> (past: Past.Index, next: Next.Index) {
        let reversed = Reversed.start(
            past: past.reversed(),
            next: next.reversed())
        
        return (reversed.past.base, reversed.next.base)
    }
}
