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

/// A namespace for the differentiation algorithm.
@usableFromInline enum Mismatches<Prev, Next> where
Prev: BidirectionalCollection<Symbol>,
Next: BidirectionalCollection<Symbol> {
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Indices = (prev: Prev.Index, next: Next.Index)
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    @inlinable static func forwards(from prev: Prev, to next: Next) -> Indices {
        var prevIndex = prev.startIndex
        var nextIndex = next.startIndex
        //=-------------------------------------=
        // Loop
        //=-------------------------------------=
        while prevIndex != prev.endIndex,
              nextIndex != next.endIndex {
            //=---------------------------------=
            // Symbols
            //=---------------------------------=
            let prevSymbol = prev[prevIndex]
            let nextSymbol = next[nextIndex]
            //=---------------------------------=
            // Indices
            //=---------------------------------=
            if prevSymbol.character == nextSymbol.character {
                prev.formIndex(after: &prevIndex)
                next.formIndex(after: &nextIndex)
            } else if prevSymbol.attribute.contains( .removable) {
                prev.formIndex(after: &prevIndex)
            } else if nextSymbol.attribute.contains(.insertable) {
                next.formIndex(after: &nextIndex)
            } else {
                break
            }
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return (prevIndex, nextIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    @inlinable static func backwards(from prev: Prev, to next: Next) -> Indices {
        typealias R = Mismatches<
        ReversedCollection<Prev>,
        ReversedCollection<Next>>

        let reversed = R.forwards(from: prev.reversed(), to: next.reversed())
        return (reversed.prev.base, reversed.next.base)
    }
}
