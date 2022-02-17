//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Naive Search Algorithm
//*============================================================================*

@usableFromInline enum Search<Needle, Haystack> where
Needle: BidirectionalCollection, Needle.Element: Equatable,
Haystack: BidirectionalCollection, Haystack.Element == Needle.Element {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Location = Range<Haystack.Index>
    @usableFromInline typealias Reversed = Search<ReversedCollection<Needle>, ReversedCollection<Haystack>>

    //=------------------------------------------------------------------------=
    // MARK: Forwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the start of the haystack.
    @inlinable static func forwards(search needle: Needle, in haystack: Haystack) -> Location? {
        //=--------------------------------------=
        // MARK: Haystack
        //=--------------------------------------=
        for start in haystack.indices {
            var position = start; var found = true
            //=----------------------------------=
            // MARK: Needle
            //=----------------------------------=
            for element in needle {
                guard position != haystack.endIndex,
                haystack[position] == element
                else { found = false; break }
                //=------------------------------=
                // MARK: Iterate
                //=------------------------------=
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
    
    /// A naive search, for needles known to be at or near the start of the haystack.
    @inlinable static func backwards(search needle: Needle, in haystack: Haystack) -> Location? {
        Reversed.forwards(search: needle.reversed(), in: haystack.reversed()).map { reversed in
            reversed.upperBound.base ..< reversed.lowerBound.base
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Forwards / Backwards
    //=------------------------------------------------------------------------=
    
    /// A naive search, for needles known to be at or near the start of the haystack.
    @inlinable static func range(of needle: Needle, in haystack: Haystack, reversed: Bool = false) -> Location? {
        !reversed ? forwards(search: needle, in: haystack) : backwards(search: needle, in: haystack)
    }
}
