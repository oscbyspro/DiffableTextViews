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
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var rawValue: [UInt8] {
        Swift.unsafeBitCast(digits, to: [UInt8].self)
    }
    
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
        
    @inlinable mutating func replaceEmptyWithZero() {
        guard digits.isEmpty else { return }
        digits.append(.zero)
    }
    
    @inlinable mutating func resize(prefix length: Int) -> Bool {
        guard length < count else { return false }
        digits.removeSubrange(digits.prefix(length).endIndex...)
        return true
    }
    
    @inlinable mutating func resize(suffix length: Int) -> Bool {
        guard length < count else { return false }
        digits.removeSubrange(..<digits.suffix(length).startIndex)
        return true
    }

    @inlinable mutating func trim(prefix predicate: (Digit) -> Bool) {
        digits.removeSubrange(..<digits.prefix(while: predicate).endIndex)
    }

    @inlinable mutating func trim(suffix predicate: (Digit) -> Bool) {
        digits.removeSubrange(digits.suffix(while: predicate).startIndex...)
    }
}
