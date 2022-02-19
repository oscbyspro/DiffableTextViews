//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Label
//*============================================================================*

/// A collection of characters at or near the end in some formatted text.
public final class Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Cache
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let currencies = Cache<CurrencyID, Label>(size: 33)
    
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are close to the edge and unique from edge to end.
    @inlinable func range(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
}

//=----------------------------------------------------------------------------=
// MARK: + Currency
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func currency(code: String, with lexicon: Lexicon) -> Label {
        let key = CurrencyID(code: code, locale: lexicon.locale)
        return currencies.search(key, make: _currency(code: code, with: lexicon))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func _currency(code: String, with lexicon: Lexicon) -> Label {
        let digit = lexicon.digits[.zero]
        //=--------------------------------------=
        // MARK: Split
        //=--------------------------------------=
        let split = IntegerFormatStyle<Int>
            .Currency(code: code).locale(lexicon.locale)
            .precision(.fractionLength(0)).format(0)
            .split(separator: digit, omittingEmptySubsequences: false)
        //=--------------------------------------=
        // MARK: Check
        //=--------------------------------------=
        guard split.count == 2 else {
            fatalError(Info([.mark(digit), "is not in", .mark(split)]).description)
        }
        //=--------------------------------------=
        // MARK: Instance
        //=--------------------------------------=
        if !split[0].filter(\.isWhitespace).isEmpty {
            return Label(split[0], at: .prefix)
        } else {
            return Label(split[1], at: .suffix)
        }
    }
}
