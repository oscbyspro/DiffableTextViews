//
//  Component.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Component
//*============================================================================*

@usableFromInline protocol Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
        
    @inlinable func write<Characters: TextOutputStream>(characters: inout Characters)
    @inlinable func write<Characters: TextOutputStream>(characters: inout Characters, in region: Region)
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String
    @inlinable func characters(in region: Region) -> String
}

//=----------------------------------------------------------------------------=
// MARK: Component - Utilities
//=----------------------------------------------------------------------------=

extension Component {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
 
    @inlinable func characters() -> String {
        var characters = ""
        write(characters: &characters)
        return characters
    }
    
    @inlinable func characters(in region: Region) -> String {
        var characters = ""
        write(characters: &characters, in: region)
        return characters
    }
}

//=----------------------------------------------------------------------------=
// MARK: Component - RawValue == Character
//=----------------------------------------------------------------------------=

extension Component where Self: RawRepresentable, RawValue == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Write
    //=------------------------------------------------------------------------=
    
    @inlinable func write<Characters: TextOutputStream>(characters: inout Characters) {
        rawValue.write(to: &characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable func characters() -> String {
        String(rawValue)
    }
}
