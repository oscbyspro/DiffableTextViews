//
//  Unicodeable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

//*============================================================================*
// MARK: * Unicodeable
//*============================================================================*

/// The unicode value of its system representation.
@usableFromInline protocol Unicodeable: RawRepresentable, CustomStringConvertible where RawValue == UInt8 { }

//=----------------------------------------------------------------------------=
// MARK: Components - Details
//=----------------------------------------------------------------------------=

extension Unicodeable {
    
    //=------------------------------------------------------------------------=
    // MARK: Unicode
    //=------------------------------------------------------------------------=
    
    @inlinable public var unicode: Unicode.Scalar {
        Unicode.Scalar(rawValue)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Character
    //=------------------------------------------------------------------------=
    
    @inlinable public var character: Character {
        Character(unicode)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(character)
    }
}
