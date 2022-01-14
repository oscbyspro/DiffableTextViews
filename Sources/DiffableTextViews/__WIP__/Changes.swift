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
        //=-------------------------------------=
        // MARK: Loop
        //=-------------------------------------=
        while pastIndex != past.endIndex,
              nextIndex != next.endIndex {
            //=---------------------------------=
            // MARK: Elements
            //=---------------------------------=
            let pastElement = past[pastIndex]
            let nextElement = next[nextIndex]
            //=---------------------------------=
            // MARK: Indices
            //=---------------------------------=
            if pastElement == nextElement {
                past.formIndex(after: &pastIndex)
                next.formIndex(after: &nextIndex)
            } else if pastElement.removable {
                past.formIndex(after: &pastIndex)
            } else if nextElement.insertable {
                next.formIndex(after: &nextIndex)
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
    // MARK: End
    //=------------------------------------------------------------------------=
    
    @inlinable static func end(past: Past, next: Next) -> (past: Past.Index, next: Next.Index) {
        //=--------------------------------------=
        // MARK: Reverse
        //=--------------------------------------=
        let reversed = Reversed.start(
            past: past.reversed(),
            next: next.reversed())
        //=--------------------------------------=
        // MARK: Finalize
        //=--------------------------------------=
        return (reversed.past.base, reversed.next.base)
    }
}
