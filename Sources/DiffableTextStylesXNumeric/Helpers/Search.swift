//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Search
//*============================================================================*

/// Naive search is OK for matching currencies.
@usableFromInline enum Search<Haystack, Needle> where
Haystack: BidirectionalCollection, Haystack.Element == Symbol,
Needle: BidirectionalCollection, Needle.Element == Character {
    @usableFromInline typealias Location = Range<Haystack.Index>
    @usableFromInline typealias Reversed = Search<ReversedCollection<Haystack>, ReversedCollection<Needle>>

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the start of a haystack.
    @inlinable static func forwards(search haystack: Haystack, match needle: Needle) -> Location? {
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
            // MARK: Success
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
    @inlinable static func backwards(search haystack: Haystack, match needle: Needle) -> Location? {
        Reversed.forwards(search: haystack.reversed(), match: needle.reversed()).map { reversed in
            reversed.upperBound.base ..< reversed.lowerBound.base
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards / Backwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the edge of a haystack.
    @inlinable static func range(of needle: Needle, in haystack: Haystack, direction: Direction) -> Location? {
        switch direction {
        case  .forwards: return  forwards(search: haystack, match: needle)
        case .backwards: return backwards(search: haystack, match: needle)
        }
    }
}
