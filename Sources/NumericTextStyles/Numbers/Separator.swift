//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Separator
//*============================================================================*

/// A system representation of a fraction separator.
@usableFromInline enum Separator: UInt8, Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case grouping = 44 // ","
    case fraction = 46 // "."
}
