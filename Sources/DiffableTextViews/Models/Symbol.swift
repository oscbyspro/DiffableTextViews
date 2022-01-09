//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

//*============================================================================*
// MARK: * Symbol
//*============================================================================*

public struct Symbol: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public var character: Character
    public var attribute: Attribute
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }

    //
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func content(_ character: Character) -> Self {
        Self(character, attribute: .content)
    }
    
    @inlinable public static func prefix(_ character: Character) -> Self {
        Self(character, attribute: .prefix)
    }
    
    @inlinable public static func suffix(_ character: Character) -> Self {
        Self(character, attribute: .suffix)
    }
    
    @inlinable public static func spacer(_ character: Character) -> Self {
        Self(character, attribute: .spacer)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Symbol - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Symbol: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    public var description: String {
        "(\(character), \(attribute))"
    }
}
