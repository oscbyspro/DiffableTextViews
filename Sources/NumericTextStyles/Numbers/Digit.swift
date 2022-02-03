//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Digit
//*============================================================================*

@usableFromInline enum Digit: UInt8, Unicodeable, CaseIterable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var isZero: Bool {
        self == .zero
    }

    @inlinable var number: UInt8 {
        rawValue - Self.zero.rawValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let system: [Character: Self] = system()
}
