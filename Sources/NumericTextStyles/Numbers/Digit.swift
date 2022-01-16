//
//  Digit.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: Digit
//*============================================================================*

@usableFromInline enum Digit: Character, CaseIterable, Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case zero  = "0"
    case one   = "1"
    case two   = "2"
    case three = "3"
    case four  = "4"
    case five  = "5"
    case six   = "6"
    case seven = "7"
    case eight = "8"
    case nine  = "9"
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
    
    @inlinable var isZero: Bool {
        self == .zero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Characters: TextOutputStream>(characters: inout Characters, in region: Region) {
        region.digitsInLocale[self]?.write(to: &characters)
    }
}
