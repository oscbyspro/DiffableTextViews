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
// MARK: * Components
//*============================================================================*

@usableFromInline struct Components {
    @usableFromInline typealias Signs = Links<Sign>
    @usableFromInline typealias Digits = Links<Digit>
    @usableFromInline typealias Separators = Links<Separator>

    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let ascii = Self(
    signs: .ascii(), digits: .ascii(), separators: .ascii())
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs: Signs
    @usableFromInline let digits: Digits
    @usableFromInline let separators: Separators

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(signs: Signs, digits: Digits, separators: Separators) {
        self.signs = signs; self.digits = digits; self.separators = separators
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self.init(
        signs:      .standard(formatter),
        digits:     .standard(formatter),
        separators: .standard(formatter))
    }
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self.init(
        signs:      .currency(formatter),
        digits:     .currency(formatter),
        separators: .currency(formatter))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func number(in  snapshot: Snapshot, as kind: (some NumberTextKind).Type) throws -> Number? {
        try .init(unformatted: snapshot.nonvirtuals, signs: signs.components,
        digits: digits.components, separators: separators.components,
        optional: kind.isOptional, unsigned: kind.isUnsigned, integer: kind.isInteger)
    }
    
    @inlinable func consumeSingleSign(in snapshot: inout Snapshot) -> Sign? {
        guard snapshot.count == 1, let sign = signs[snapshot.first!.character] else { return nil }
        snapshot = Snapshot();  return sign
    }
}
