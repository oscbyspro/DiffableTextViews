//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Label
//*============================================================================*

/// A collection of characters at or near the edge of some formatted text.
public final class Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let characters: String
    @usableFromInline let location: Location
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<S: StringProtocol>(_ characters: S, at location: Location) {
        self.location = location
        self.characters = String(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    @inlinable static func currency(_ lexicon: Lexicon, code: String) -> Label {
        let labels = IntegerFormatStyle<Int>
        .Currency(code: code).locale(lexicon.locale)
        .precision(.fractionLength(0)).format(0)
        .split(separator: lexicon.digits[.zero],
        omittingEmptySubsequences: false)
        //=--------------------------------------=
        // MARK: Expectation
        //=--------------------------------------=
        assert(labels.count == 2)
        //=--------------------------------------=
        // MARK: Instantiate
        //=--------------------------------------=
        if !labels[0].filter(\.isWhitespace).isEmpty {
            return Label(labels[0], at: .prefix)
        } else {
            assert(!labels[1].filter(\.isWhitespace).isEmpty)
            return Label(labels[1], at: .suffix)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are at or near to the edge.
    @inlinable func range(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
}
