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
// MARK: * Digit
//*============================================================================*

@usableFromInline struct Digit: _Token {
    @usableFromInline static let allCases = [
    zero, one, two,   three, four,
    five, six, seven, eight, nine]
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero  = Self(ascii: 48) // "0"
    @usableFromInline static let one   = Self(ascii: 49) // "1"
    @usableFromInline static let two   = Self(ascii: 50) // "2"
    @usableFromInline static let three = Self(ascii: 51) // "3"
    @usableFromInline static let four  = Self(ascii: 52) // "4"
    @usableFromInline static let five  = Self(ascii: 53) // "5"
    @usableFromInline static let six   = Self(ascii: 54) // "6"
    @usableFromInline static let seven = Self(ascii: 55) // "7"
    @usableFromInline static let eight = Self(ascii: 56) // "8"
    @usableFromInline static let nine  = Self(ascii: 57) // "9"
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let ascii: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(ascii: UInt8) { self.ascii = ascii }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isZero: Bool {
        self == Self.zero
    }
    
    @inlinable var numericValue: UInt8 {
        ascii - Self.zero.ascii
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Requires that formatter.numberStyle == .none.
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        assert(formatter.numberStyle == .none)
        return formatter.string(from: numericValue as NSNumber)!.first
    }
}
