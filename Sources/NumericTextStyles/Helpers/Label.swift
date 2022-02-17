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

@usableFromInline final class Label {
    
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
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable convenience init() {
        self.init(String(), at: .prefix)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    @usableFromInline enum Location { case prefix, suffix }
}

//=----------------------------------------------------------------------------=
// MARK: + Unformat
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable func unformat(snapshot: inout Snapshot) {
        guard !characters.isEmpty else { return }
        guard let range = range(in: snapshot) else { return }
        snapshot.update(attributes: range) {
            attribute in attribute.insert(.virtual)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Naive search is OK because labels are close to the edge and unique from edge to end.
    @inlinable func range(in snapshot: Snapshot) -> Range<Snapshot.Index>? {
        Search.range(of: characters, in: snapshot, reversed: location == .suffix)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Currency
//=----------------------------------------------------------------------------=

extension Label {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func currency(code: String, in region: Region) -> Self {
        let digit = region.digits[.zero]
        //=--------------------------------------=
        // MARK: Split
        //=--------------------------------------=
        let split = IntegerFormatStyle<Int>
            .Currency(code: code).locale(region.locale)
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
        return !split[0].isEmpty ? Self(split[0], at: .prefix) : Self(split[1], at: .suffix)
    }
}
