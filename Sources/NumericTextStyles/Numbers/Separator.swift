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
// MARK: * Separator
//*============================================================================*

/// A system representation of a separator.
@usableFromInline enum Separator: UInt8, Unit {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case grouping = 44 // ","
    case fraction = 46 // "."
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character? {
        var characters: String { switch self {
        case .grouping: return formatter.groupingSeparator
        case .fraction: return formatter .decimalSeparator
        }}; return characters.first
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character? {
        var characters: String { switch self {
        case .grouping: return formatter.currencyGroupingSeparator
        case .fraction: return formatter .currencyDecimalSeparator
        }}; return characters.first
    }
}
