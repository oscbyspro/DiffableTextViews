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
        character: "\u{200B}",
        attribute: [.virtual, .insertable, .removable])
    
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
    
    @inlinable public static func format(_ character: Character) -> Self {
        Self(character: character, attribute: .format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Predicates
    //=------------------------------------------------------------------------=
    
    @inlinable public func `is`(_ attribute: Attribute) -> Bool {
        attribute.contains(attribute)
    }
    
    @inlinable public func `is`(not attribute: Attribute) -> Bool {
        attribute.contains(attribute) == false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Predicates - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func `is`(_ attribute: Attribute) -> (Self) -> Bool {{
        $0.attribute.contains(attribute)
    }}
    
    @inlinable public static func `is`(not attribute: Attribute) -> (Self) -> Bool {{
        $0.attribute.contains(attribute) == false
    }}
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
