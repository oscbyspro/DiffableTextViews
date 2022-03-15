//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Label
//*============================================================================*

/// A collection of characters at or near the edge of some formatted text.
@usableFromInline final class Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let characters: String
    @usableFromInline let location: Location
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<S>(_ characters: S, at location: Location) where S: StringProtocol {
        self.characters = String(characters); self.location = location
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=

    /// Correctness is assert by tests parsing currency formats for all locale-currency pairs.
    @inlinable static func currency(_ id: Schemes.Currency.ID, _ lexicon: Lexicon) -> Label {
        let labels = IntegerFormatStyle<Int>
        .Currency(code: id.code, locale: id.locale)
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
        switch !labels[0].filter(\.isWhitespace).isEmpty {
        case  true: return Label(labels[0], at: .prefix)
        case false: return Label(labels[1], at: .suffix)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are at or near to the edge.
    @inlinable func indices(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
}
