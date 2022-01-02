//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#warning("Remove, maybe.")
import protocol Utilities.Transformable

//*============================================================================*
// MARK: * Symbol
//*============================================================================*

public struct Symbol: Equatable, Transformable {
    
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

    // MARK: Predicates
    
    @inlinable public func `is`(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
    
    @inlinable public func `is`(non attribute: Attribute) -> Bool {
        !self.attribute.contains(attribute)
    }
    
    // MARK: Predicates: Static
    
    @inlinable public static func `is`(_ attribute: Attribute) -> (Self) -> Bool {{
        $0.is(attribute)
    }}
    
    @inlinable public static func `is`(non attribute: Attribute) -> (Self) -> Bool {{
        $0.is(non: attribute)
    }}
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
