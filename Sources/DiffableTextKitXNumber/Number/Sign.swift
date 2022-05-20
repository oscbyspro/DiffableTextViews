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
// MARK: Declaration
//*============================================================================*

@usableFromInline struct Sign: Glyph {
    
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
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init?<T>(of bounds: ClosedRange<T>) where T: NumberTextValue {
        if      bounds.lowerBound >= .zero { self = .positive }
        else if bounds.upperBound <= .zero && bounds.lowerBound != .zero { self = .negative }
        else { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func toggle() {
        self = toggled()
    }
    
    @inlinable func toggled() -> Self {
        switch enumeration {
        case .positive: return .negative
        case .negative: return .positive
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        var characters: String { switch enumeration {
        case .positive: return formatter .plusSign
        case .negative: return formatter.minusSign
        }}; return characters.first{ $0.isPunctuation || $0.isMathSymbol }
    }
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*
    
    @usableFromInline enum Enumeration: UInt8, CaseIterable {
        case positive = 43 // "+"
        case negative = 45 // "-"
    }
}
