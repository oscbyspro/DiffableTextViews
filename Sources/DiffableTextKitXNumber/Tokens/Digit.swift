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

@usableFromInline struct Digit: Token {
    @usableFromInline static let allCases = (48 ..< 58).map(Self.init)
    
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        formatter.string(from: ascii - Self.zero.ascii as NSNumber)!.first
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        self.standard(formatter)
    }
}
