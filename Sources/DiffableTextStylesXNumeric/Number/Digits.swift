//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Digits
//*============================================================================*

@usableFromInline struct Digits: Glyphs {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var digits: [Digit]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { self.digits = [] }
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    @inlinable var count: Int {
        digits.count
    }
    
    @inlinable func count(prefix predicate: (Digit) -> Bool) -> Int {
        digits.count(while: predicate)
    }
    
    @inlinable func count(suffix predicate: (Digit) -> Bool) -> Int {
        digits.reversed().count(while: predicate)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ element: Digit) {
        digits.append(element)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Replace
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func makeAtLeastZero() {
        if  digits.isEmpty {
            digits.append(.zero)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Prefix / Suffix
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func trimZerosPrefix() {
        digits.removeSubrange(..<digits.prefix(while: \.isZero).endIndex)
    }
    
    @inlinable mutating func trimZerosSuffix() {
        digits.removeSubrange(digits.suffix(while: \.isZero).startIndex...)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Prefix / Suffix
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func prefix(maxLength: Int) {
        digits = Array(digits.prefix(maxLength))
    }
    
    @inlinable mutating func suffix(maxLength: Int) {
        digits = Array(digits.suffix(maxLength))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Digits: TextOutputStreamable {
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<T>(to target: inout T) where T: TextOutputStream {
        for digit in digits {
            digit.write(to: &target)
        }
    }
}
