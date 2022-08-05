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

/// A model for marking labels as virtual.
@usableFromInline struct Label {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let text: String
    @usableFromInline let direction: Direction
    @usableFromInline let autocorrection: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ text: String, direction: Direction) {
        self.text = text; self.direction = direction; self.autocorrection = true
    }
    
    @inlinable init(_ text: String, zero: String, with components: Components) {
        let sides = zero.split(separator:components.digits[.zero], omittingEmptySubsequences: false)
        self.text = text; self.direction = sides[0].contains(text) ? Direction.forwards : .backwards
        self.autocorrection = !text.allSatisfy(components.virtual)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    /// Correctness is asserted by parsing all combinations.
    @inlinable static func currency(_ formatter: NumberFormatter,
    with components: Components) -> Self {
        assert(formatter.numberStyle == .currency)
        assert(formatter.maximumFractionDigits == 0)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        let label = formatter.currencySymbol!
        let zero  = formatter.string(from:0)!
        return Self(label, zero: zero, with: components)
    }
    
    #warning("This needs tests............................")
    /// Correctness is asserted by parsing all combinations.
    @inlinable static func measurement(_ formatter: MeasurementFormatter,
    unit: some Unit, with components: Components) -> Self {
        assert(formatter.numberFormatter.numberStyle == .none);
        assert(formatter.numberFormatter.maximumFractionDigits  == 0)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        let zero  = formatter.string(from: Measurement(value: 0.0, unit: unit))
        return Self(formatter.string(from: unit), zero: zero, with: components)
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot) {
        guard autocorrection, let label = Search.range(
        of: text, in: snapshot, towards: direction) else {  return  }
        snapshot.transform(attributes: label, with: { $0 = .phantom })
    }
}
