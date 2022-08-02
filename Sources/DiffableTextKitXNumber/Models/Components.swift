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
    
    @usableFromInline static let ascii = Self(
    signs: .ascii(), digits: .ascii(), separators: .ascii())
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let signs:      Links<Sign>
    @usableFromInline let digits:     Links<Digit>
    @usableFromInline let separators: Links<Separator>

    //=------------------------------------------------------------------------=
    
    @inlinable init(signs: Links<Sign>, digits: Links<Digit>, separators: Links<Separator>) {
        self.signs      = signs
        self.digits     = digits
        self.separators = separators
    }
    
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self.init(
        signs:      .standard(formatter),
        digits:     .standard(formatter),
        separators: .standard(formatter))
    }
    
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self.init(
        signs:      .currency(formatter),
        digits:     .currency(formatter),
        separators: .currency(formatter))
    }
}
