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
    
    @inlinable init(_ label: String, direction: Direction) {
        self.label = label;  self.direction = direction
    }
    
    /// Returns an instance if it contains nonvirtual characters; returns nil otherwise.
    @inlinable init?(_ label: String, zero: String, with components: Components) {
        if label.allSatisfy(components.virtual) { return nil }
        //=--------------------------------------=
        // Contains Nonvirtual Characters
        //=--------------------------------------=
        let  digit = components.digits[.zero]
        let  sides = zero.split(separator: digit, omittingEmptySubsequences: false)
        self.label = label; self.direction = sides[0].contains(label) ? .forwards : .backwards
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    /// Correctness is asserted by parsing all permutations.
    @inlinable static func currency(_ formatter: NumberFormatter,
    with components: Components) -> Self? {
        assert(formatter.numberStyle == .currency)
        assert(formatter.maximumFractionDigits == 0)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        let label = formatter.currencySymbol!
        let zero = formatter.string(from: 0)!
        return Self(label, zero: zero, with: components)
    }
    
    #warning("This needs tests............................")
    /// Correctness is asserted by parsing all permutations.
    @inlinable static func measurement(_ formatter: MeasurementFormatter,
    unit: some Unit, with components: Components) -> Self? {
        assert(formatter.numberFormatter.numberStyle == .none);
        assert(formatter.numberFormatter.maximumFractionDigits  == 0)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        let label = formatter.string(from: unit)
        let zero  = formatter.string(from: Measurement(value: 0, unit: unit))
        return Self(label, zero: zero, with: components)
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
