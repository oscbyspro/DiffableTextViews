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
    
    @inlinable init(digits: [Digit] = []) {
        self.digits = digits
    }
    
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
    
    @inlinable mutating func makeAtLeastZero() {
        if digits.isEmpty { digits.append(.zero) }
    }

    @inlinable mutating func removeZerosAsPrefix() {
        digits.removeSubrange(..<digits.prefix(while: \.isZero).endIndex)
    }
    
    @inlinable mutating func removeZerosAsSuffix() {
        digits.removeSubrange(digits.suffix(while: \.isZero).startIndex...)
    }
    
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

extension Digits {
    
    //=------------------------------------------------------------------------=
    // MARK: ASCII
    //=------------------------------------------------------------------------=
    
    /// Requires that digits is of type [Digit].
    @inlinable var rawValue: [UInt8] {
        Swift.unsafeBitCast(digits, to: [UInt8].self)
    }
}
