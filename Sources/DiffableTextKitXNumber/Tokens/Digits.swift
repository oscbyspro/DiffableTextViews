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

@usableFromInline struct Digits: Tokens {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var tokens: [Digit]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(tokens: [Digit] = []) { self.tokens = tokens }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var ascii: [UInt8] {
        Swift.unsafeBitCast(tokens, to: [UInt8].self)
    }
    
    @inlinable var count: Int {
        tokens.count // is O(1)
    }
    
    @inlinable func count(prefix predicate: (Digit) -> Bool) -> Int {
        tokens.count(while: predicate)
    }
    
    @inlinable func count(suffix predicate: (Digit) -> Bool) -> Int {
        tokens.reversed().count(while: predicate)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ digit: Digit) {
        tokens.append(digit)
    }
        
    @inlinable mutating func atLeastZero() {
        guard tokens.isEmpty else { return }
        tokens.append(.zero)
    }
    
    @inlinable mutating func resize(prefix length: Int) -> Bool {
        guard length < count else { return false }
        tokens.removeSubrange(tokens.prefix(length).endIndex...)
        return true
    }
    
    @inlinable mutating func resize(suffix length: Int) -> Bool {
        guard length < count else { return false }
        tokens.removeSubrange(..<tokens.suffix(length).startIndex)
        return true
    }

    @inlinable mutating func trim(prefix predicate: (Digit) -> Bool) {
        tokens.removeSubrange(..<tokens.prefix(while: predicate).endIndex)
    }

    @inlinable mutating func trim(suffix predicate: (Digit) -> Bool) {
        tokens.removeSubrange(tokens.suffix(while: predicate).startIndex...)
    }
}
