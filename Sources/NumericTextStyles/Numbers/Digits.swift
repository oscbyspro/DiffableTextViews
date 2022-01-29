//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Support

//*============================================================================*
// MARK: * Digits
//*============================================================================*

@usableFromInline struct Digits: ExpressibleByArrayLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var digits: [Digit]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ digits: [Digit] = []) {
        self.digits = []
    }
    
    @inlinable init(arrayLiteral elements: Digit...) {
        self.digits = elements
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Replace
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func makeItAtLeastZero() {
        if digits.isEmpty { self = [.zero] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Prefix / Suffix
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func removeZerosPrefix() {
        digits.removeSubrange(..<digits.prefix(while: \.isZero).endIndex)
    }
    
    @inlinable mutating func removeZerosSuffix() {
        digits.removeSubrange(digits.suffix(while: \.isZero).startIndex...)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations - Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func prefix(maxLength: Int) {
        digits = Array(digits.prefix(maxLength))
    }
    
    @inlinable mutating func suffix(maxLength: Int) {
        digits = Array(digits.suffix(maxLength))
    }
}
