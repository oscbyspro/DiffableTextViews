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

@usableFromInline struct Separator: Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let grouping = Self(.grouping)
    @usableFromInline static let fraction = Self(.fraction)
    
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
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        var characters: String { switch enumeration {
        case .grouping: return formatter.groupingSeparator
        case .fraction: return formatter .decimalSeparator
        }}; return characters.first
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        var characters: String { switch enumeration {
        case .grouping: return formatter.currencyGroupingSeparator
        case .fraction: return formatter .currencyDecimalSeparator
        }}; return characters.first
    }
    
    //*========================================================================*
    // MARK: Enumeration
    //*========================================================================*
    
    @usableFromInline enum Enumeration: UInt8, CaseIterable {
        case grouping = 44 // ","
        case fraction = 46 // "."
    }
}
