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
    /// Correctness is assert by tests parsing currency formats for all locale-currency pairs.
    ///
    /// - Requires that formatter.numberStyle == .currency.
    /// - Requires that formatter.maximumFractionDigits == .zero.
    ///
    @inlinable static func currency(_ formatter: NumberFormatter, _ components: Components) -> Self? {
        let label = formatter.currencySymbol!
        //=--------------------------------------=
        // Necessity
        //=--------------------------------------=
        assert(formatter.numberStyle == .currency)
        guard label.contains(components.separators[.fraction]) else { return nil }
        //=--------------------------------------=
        // Formatted
        //=--------------------------------------=
        let sides = formatter.string(from: 0)!.split(
        separator: components.digits[.zero], omittingEmptySubsequences: false)
        //=--------------------------------------=
        // Direction
        //=--------------------------------------=
        let direction: Direction
        
        switch sides[0].contains(label) {
        case  true: direction =  .forwards
        case false: direction = .backwards; assert(sides[1].contains(label))
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return .init(label: label, direction: direction)
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        if let range = Search.range(of: label, in: snapshot, towards: direction) {
            snapshot.transform(attributes: range) { $0 = .phantom }
        }
    }
}
