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
@usableFromInline enum Mismatches<Prev, Next> where
Prev: BidirectionalCollection, Prev.Element == Symbol,
Next: BidirectionalCollection, Next.Element == Symbol {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Indices = (prev: Prev.Index, next: Next.Index)
    @usableFromInline typealias Reversed = Mismatches<ReversedCollection<Prev>, ReversedCollection<Next>>

    //=------------------------------------------------------------------------=
    // MARK: Prefix
    //=------------------------------------------------------------------------=
    
    /// Returns caret positions before the first irreconcilable mismatch forwards.
    @inlinable static func prefix(prev: Prev, next: Next) -> Indices {
        var prevIndex = prev.startIndex
        var nextIndex = next.startIndex
        //=-------------------------------------=
        // MARK: Loop
        //=-------------------------------------=
        while prevIndex != prev.endIndex,
              nextIndex != next.endIndex {
            //=---------------------------------=
            // MARK: Elements
            //=---------------------------------=
            let pastElement = prev[prevIndex]
            let nextElement = next[nextIndex]
            //=---------------------------------=
            // MARK: Indices
            //=---------------------------------=
            if pastElement.character == nextElement.character {
                prev.formIndex(after: &prevIndex)
                next.formIndex(after: &nextIndex)
            } else if pastElement.contains(.removable) {
                prev.formIndex(after: &prevIndex)
            } else if nextElement.contains(.insertable) {
                next.formIndex(after: &nextIndex)
            } else {
                break
            }
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return (prevIndex, nextIndex)
    }
    
    @inlinable static func prefix(next: Next, prev: Prev) -> Indices {
        prefix(prev: prev, next: next)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Suffix
    //=------------------------------------------------------------------------=
    
    /// Returns caret positions before the first irreconcilable mismatch backwards.
    @inlinable static func suffix(prev: Prev, next: Next) -> Indices {
        let reversed = Reversed.prefix(
        prev: prev.reversed(), next: next.reversed())
        return (reversed.prev.base, reversed.next.base)
    }
    
    @inlinable static func suffix(next: Next, prev: Prev) -> Indices {
        suffix(prev: prev, next: next)
    }
}
