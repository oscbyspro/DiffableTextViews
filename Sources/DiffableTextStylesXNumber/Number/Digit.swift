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

@usableFromInline struct Digit: Glyph {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero  = Self(.zero)
    @usableFromInline static let one   = Self(.one)
    @usableFromInline static let two   = Self(.two)
    @usableFromInline static let three = Self(.three)
    @usableFromInline static let four  = Self(.four)
    @usableFromInline static let five  = Self(.five)
    @usableFromInline static let six   = Self(.six)
    @usableFromInline static let seven = Self(.seven)
    @usableFromInline static let eight = Self(.eight)
    @usableFromInline static let nine  = Self(.nine)
    
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
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isZero: Bool {
        self == Digit.zero
    }
    
    @inlinable var numericValue: UInt8 {
        rawValue - Digit.zero.rawValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Localization
    //=------------------------------------------------------------------------=
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        assert(formatter.numberStyle == .none)
        return formatter.string(from: numericValue as NSNumber)!.first
    }
    
    //*========================================================================*
    // MARK: Enumeration
    //*========================================================================*
    
    @usableFromInline enum Enumeration: UInt8, CaseIterable {
        case zero  = 48 // "0"
        case one   = 49 // "1"
        case two   = 50 // "2"
        case three = 51 // "3"
        case four  = 52 // "4"
        case five  = 53 // "5"
        case six   = 54 // "6"
        case seven = 55 // "7"
        case eight = 56 // "8"
        case nine  = 57 // "9"
    }
}
