//
//  Digits.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Digits
//*============================================================================*

@usableFromInline struct Digits: Component, ExpressibleByArrayLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let zero: Self = [.x0]
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var digits: [Digit]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.digits = []
    }
    
    @inlinable init(arrayLiteral digits: Digit...) {
        self.digits = digits
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
    
    @inlinable mutating func replaceEmptyWithZero() {
        if digits.isEmpty { self = .zero }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Text
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Target: TextOutputStream>(to target: inout Target) {
        for digits in digits {
            digits.write(to: &target)
        }
    }
}
