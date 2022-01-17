//
//  Count.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-24.
//

//*============================================================================*
// MARK: * Count
//*============================================================================*

/// - Value is shorthand for significant digits.
public struct Count {

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var value: Int
    @usableFromInline var integer: Int
    @usableFromInline var fraction: Int

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init(value: Int, integer: Int, fraction: Int) {
        self.value = value
        self.integer = integer
        self.fraction = fraction
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(component: Component) -> Int {
        switch component {
        case .value:    return value
        case .integer:  return integer
        case .fraction: return fraction
        }
    }
    
    //*========================================================================*
    // MARK: Component
    //*========================================================================*
    
    @usableFromInline enum Component {
        case value
        case integer
        case fraction
    }
}
