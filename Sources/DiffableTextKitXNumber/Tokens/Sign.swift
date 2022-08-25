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

@usableFromInline struct Sign: Token {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let positive = Self(ascii: "+")
    @usableFromInline static let negative = Self(ascii: "-")
    
    @usableFromInline static let allCases = [positive, negative]

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let ascii: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    private init(ascii: Unicode.Scalar) {
        self.ascii = UInt8(ascii:ascii)
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
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! { switch self {
        case .positive: return formatter .plusSign.first { $0.isPunctuation || $0.isMathSymbol }
        default:        return formatter.minusSign.first { $0.isPunctuation || $0.isMathSymbol } }
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        self.standard(formatter)
    }
}
