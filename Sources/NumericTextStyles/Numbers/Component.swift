//
//  Component.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

//*============================================================================*
// MARK: * Component
//*============================================================================*

/// The unicode value of its system representation.
@usableFromInline protocol Component: RawRepresentable where RawValue == UInt8 { }

//=----------------------------------------------------------------------------=
// MARK: Components - Details
//=----------------------------------------------------------------------------=

extension Component {
        
    //=------------------------------------------------------------------------=
    // MARK: Character
    //=------------------------------------------------------------------------=
    
    @inlinable var character: Character {
        Character(unicode)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Unicode
    //=------------------------------------------------------------------------=
    
    @inlinable var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
}
