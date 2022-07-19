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

@usableFromInline struct Sign: _Token {
    @usableFromInline static let allCases = Enumeration.allCases.map(Self.init)
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let positive = Self(.positive)
    @usableFromInline static let negative = Self(.negative)

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let rawValue: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ enumeration: Enumeration) {
        self.rawValue = enumeration.rawValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func toggle() {
        self = toggled()
    }
    
    @inlinable func toggled() -> Self {
        self == .positive ? .negative : .positive
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        var characters: String { switch enumeration {
        case .positive: return formatter .plusSign
        case .negative: return formatter.minusSign
        }}; return characters.first{ $0.isPunctuation || $0.isMathSymbol }
    }
    
    //*========================================================================*
    // MARK: * Enumeration
    //*========================================================================*
    
    @usableFromInline enum Enumeration: UInt8, CaseIterable {
        case positive = 43 // "+"
        case negative = 45 // "-"
    }
}
