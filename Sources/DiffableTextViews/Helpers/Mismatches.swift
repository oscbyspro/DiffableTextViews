//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Mismatches
//*============================================================================*

/// A namespace for the algorithm that detects changes between snapshots.
@usableFromInline enum Mismatches<Past, Next> where
Past: BidirectionalCollection, Past.Element == Symbol,
Next: BidirectionalCollection, Next.Element == Symbol {
    @usableFromInline typealias Indices = (past: Past.Index, next: Next.Index)
    @usableFromInline typealias Reversed = Mismatches<ReversedCollection<Past>, ReversedCollection<Next>>

    //=------------------------------------------------------------------------=
    // MARK: Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns caret positions before the first irreconcilable mismatch.
    @inlinable static func prefix(past: Past, next: Next) -> Indices {
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
            if pastElement.character == nextElement.character {
                past.formIndex(after: &pastIndex)
                next.formIndex(after: &nextIndex)
            } else if pastElement.contains(.removable) {
                past.formIndex(after: &pastIndex)
            } else if nextElement.contains(.insertable) {
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
    // MARK: Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns caret positions after the first irreconcilable mismatch.
    @inlinable static func suffix(past: Past, next: Next) -> Indices {
        //=--------------------------------------=
        // MARK: Reversed
        //=--------------------------------------=
        let reversed = Reversed.prefix(
            past: past.reversed(),
            next: next.reversed())
        //=--------------------------------------=
        // MARK: Finalize
        //=--------------------------------------=
        return (reversed.past.base, reversed.next.base)
    }
}
