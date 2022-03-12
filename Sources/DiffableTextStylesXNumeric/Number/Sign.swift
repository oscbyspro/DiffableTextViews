//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Sign
//*============================================================================*

@usableFromInline enum Sign: UInt8, Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case positive = 43 // "+"
    case negative = 45 // "-"
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func toggle() {
        self = toggled()
    }
    
    @inlinable func toggled() -> Self {
        switch self {
        case .positive: return .negative
        case .negative: return .positive
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        var characters: String { switch self {
        case .positive: return formatter .plusSign
        case .negative: return formatter.minusSign
        }}; return characters.first(where: { $0.isPunctuation || $0.isMathSymbol })
    }
}
