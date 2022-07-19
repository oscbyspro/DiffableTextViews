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

@usableFromInline struct Separator: _Token {
    @usableFromInline static let allCases = [grouping, fraction]
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let grouping = Self(ascii: 44) // ","
    @usableFromInline static let fraction = Self(ascii: 46) // "."
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let ascii: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(ascii: UInt8) { self.ascii = ascii }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! { switch self {
        case .grouping: return formatter.groupingSeparator.first
        default:        return formatter .decimalSeparator.first }
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! { switch self {
        case .grouping: return formatter.currencyGroupingSeparator.first
        default:        return formatter .currencyDecimalSeparator.first }
    }
}
