//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//*============================================================================*
// MARK: * Naive Search Algorithm
//*============================================================================*

@usableFromInline enum Search<Needle, Haystack> where
Needle: BidirectionalCollection, Needle.Element == Character,
Haystack: BidirectionalCollection, Haystack.Element == Symbol {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Location = Range<Haystack.Index>
    @usableFromInline typealias Reversed = Search<ReversedCollection<Needle>, ReversedCollection<Haystack>>

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the start of a haystack.
    @inlinable static func forwards(search needle: Needle, in haystack: Haystack) -> Location? {
        //=--------------------------------------=
        // MARK: Haystack
        //=--------------------------------------=
        for start in haystack.indices {
            var position = start; var found = true
            //=----------------------------------=
            // MARK: Needle
            //=----------------------------------=
            for character in needle {
                guard position != haystack.endIndex,
                character == haystack[position].character
                else { found = false; break }
                haystack.formIndex(after: &position)
            }
            //=----------------------------------=
            // MARK: Found
            //=----------------------------------=
            if found { return start ..< position }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        return nil
    }

    //=------------------------------------------------------------------------=
    // MARK: Backwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the end of a haystack.
    @inlinable static func backwards(search needle: Needle, in haystack: Haystack) -> Location? {
        Reversed.forwards(search: needle.reversed(), in: haystack.reversed()).map { reversed in
            reversed.upperBound.base ..< reversed.lowerBound.base
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards / Backwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the edge of a haystack.
    @inlinable static func range(of needle: Needle, in haystack: Haystack, reversed: Bool = false) -> Location? {
        !reversed ? forwards(search: needle, in: haystack) : backwards(search: needle, in: haystack)
    }
}
