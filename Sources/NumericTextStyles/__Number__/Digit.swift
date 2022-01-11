//
//  Digit.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: Digit
//*============================================================================*

@usableFromInline enum Digit: String, CaseIterable, Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case x0 = "0"
    case x1 = "1"
    case x2 = "2"
    case x3 = "3"
    case x4 = "4"
    case x5 = "5"
    case x6 = "6"
    case x7 = "7"
    case x8 = "8"
    case x9 = "9"
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var isZero: Bool {
        self == .x0
    }
}
