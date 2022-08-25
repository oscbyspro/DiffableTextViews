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
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero  = Self(ascii: "0")
    @usableFromInline static let one   = Self(ascii: "1")
    @usableFromInline static let two   = Self(ascii: "2")
    @usableFromInline static let three = Self(ascii: "3")
    @usableFromInline static let four  = Self(ascii: "4")
    @usableFromInline static let five  = Self(ascii: "5")
    @usableFromInline static let six   = Self(ascii: "6")
    @usableFromInline static let seven = Self(ascii: "7")
    @usableFromInline static let eight = Self(ascii: "8")
    @usableFromInline static let nine  = Self(ascii: "9")
    
    @usableFromInline static let allCases = [
    zero, one, two,   three, four,
    five, six, seven, eight, nine]
    
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func standard(_ formatter: NumberFormatter) -> Character! {
        formatter.string(from: ascii - Self.zero.ascii as NSNumber)!.first
    }
    
    @inlinable func currency(_ formatter: NumberFormatter) -> Character! {
        self.standard(formatter)
    }
}
