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
    
    @inlinable init(digits: [Digit] = []) {
        self.digits = []
    }
    
    @inlinable init(arrayLiteral elements: Digit...) {
        self.digits = elements
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var count: Int {
        digits.count
    }
    
    @inlinable func prefixZerosCount() -> Int {
        digits.count(while: \.isZero)
    }
    
    @inlinable func suffixZerosCount() -> Int {
        digits.reversed().count(while: \.isZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ element: Digit) {
        digits.append(element)
    }
    
    @inlinable mutating func removeZerosPrefix() {
        digits.removeSubrange(..<digits.prefix(while: \.isZero).endIndex)
    }
    
    @inlinable mutating func removeZerosSuffix() {
        digits.removeSubrange(digits.suffix(while: \.isZero).startIndex...)
    }
    
    @inlinable mutating func makeItAtLeastZero() {
        if digits.isEmpty { self = [.zero] }
    }
}
