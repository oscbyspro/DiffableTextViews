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
// MARK: * Currecny x Label
//*============================================================================*

/// A model for marking real currency symbols as virtual.
@usableFromInline struct _Currency_Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let label: String
    @usableFromInline let direction: Direction

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
    @inlinable init?(_ formatter: NumberFormatter, _ components: Components) {
        self.label = formatter.currencySymbol
        //=----------------------------------=
        // Necessity
        //=----------------------------------=
        guard label.contains(components.separators[.fraction]) else { return nil }
        //=----------------------------------=
        // Formatted
        //=----------------------------------=
        let sides = formatter.string(from: 0)!.split(
        separator: components.digits[.zero], omittingEmptySubsequences: false)
        //=----------------------------------=
        // Direction
        //=----------------------------------=
        switch sides[0].contains(label) {
        case  true: self.direction =  .forwards
        case false: self.direction = .backwards; assert(sides[1].contains(label))
        }
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
