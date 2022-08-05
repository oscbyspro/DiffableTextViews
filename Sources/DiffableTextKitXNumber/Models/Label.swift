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

#warning("Update this to accommodate measurements.............................")
//*============================================================================*
// MARK: * Label
//*============================================================================*

/// A model for marking real currency symbols as virtual.
@usableFromInline struct Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let label: String
    @usableFromInline let direction: Direction

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(label: String, direction: Direction) {
        self.label = label;  self.direction = direction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns an instance if it is needed, returns nil otherwise.
    ///
    /// Correctness is known by tests parsing currency formats for all locale-currency pairs.
    ///
    @inlinable static func currency(_ formatter: NumberFormatter, _ components: Components) -> Self? {
        assert(formatter.numberStyle == .currency)
        assert(formatter.maximumFractionDigits == 0)
        //=--------------------------------------=
        // Necessity
        //=--------------------------------------=
        let label = formatter.currencySymbol!
        guard label.contains(components.separators[.fraction]) else { return nil }
        //=--------------------------------------=
        // Direction
        //=--------------------------------------=
        let sides = formatter.string(from: 0)!.split(
        separator: components.digits[Digit.zero], omittingEmptySubsequences:  false)
        let direction: Direction = sides[0].contains(label) ? .forwards : .backwards
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Self(label: label, direction: direction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_  snapshot: inout Snapshot) {
        if let label = Search.range(of: label, in: snapshot, towards: direction) {
            snapshot.transform(attributes: label, with: { $0 = Attribute.phantom })
        }
    }
}
