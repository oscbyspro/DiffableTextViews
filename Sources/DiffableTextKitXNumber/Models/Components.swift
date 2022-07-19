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
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let ascii = Self(
    signs: .ascii(), digits: .ascii(), separators: .ascii())
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs:      Links<Sign>
    @usableFromInline let digits:     Links<Digit>
    @usableFromInline let separators: Links<Separator>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(signs: Links<Sign>, digits: Links<Digit>, separators: Links<Separator>) {
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
    
    @inlinable func consumeSingleSign(in snapshot: inout Snapshot) -> Sign? {
        guard snapshot.count == 1, let sign =
        signs[snapshot.first!.character] else { return nil }
        snapshot = Snapshot();  return sign
    }
}
