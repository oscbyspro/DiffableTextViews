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
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    public static let anchor = Self(
        character: "\u{200B}", // a zero-width space
        attribute: .phantom.subtracting(.passthrough))
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public var character: Character
    public var attribute: Attribute
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func content(_ character: Character) -> Self {
        Self(character: character, attribute: .content)
    }
    
    @inlinable public static func phantom(_ character: Character) -> Self {
        Self(character: character, attribute: .phantom)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Symbol - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Symbol: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "(\(character), \(attribute))"
    }
}
