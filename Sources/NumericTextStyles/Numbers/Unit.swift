//
//  Unit.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-16.
//

//*============================================================================*
// MARK: * Unit
//*============================================================================*

/// The unicode value of its system representation.
@usableFromInline protocol Unit: RawRepresentable, CustomStringConvertible where RawValue == UInt8 { }

//=----------------------------------------------------------------------------=
// MARK: Components - Details
//=----------------------------------------------------------------------------=

extension Unit {
    
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
