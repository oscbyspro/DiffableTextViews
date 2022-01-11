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
    
    @inlinable public init(character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }

    //
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func content(_ character: Character) -> Self {
        Self(character: character, attribute: .content)
    }
    
    @inlinable public static func prefix(_ character: Character) -> Self {
        Self(character: character, attribute: .prefix)
    }
    
    @inlinable public static func suffix(_ character: Character) -> Self {
        Self(character: character, attribute: .suffix)
    }
    
    @inlinable public static func spacer(_ character: Character) -> Self {
        Self(character: character, attribute: .spacer)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions - Formatting
    //=------------------------------------------------------------------------=
    
    @inlinable public var formatting: Bool {
        attribute.contains(.formatting)
    }
    
    @inlinable public var nonformatting: Bool {
        !attribute.contains(.formatting)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions - Insertable
    //=------------------------------------------------------------------------=
    
    @inlinable public var insertable: Bool {
        attribute.contains(.insertable)
    }
    
    @inlinable public var noninsertable: Bool {
        attribute.contains(.insertable) == false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions - Removable
    //=------------------------------------------------------------------------=
    
    @inlinable public var removable: Bool {
        attribute.contains(.removable)
    }
    
    @inlinable public var nonremovable: Bool {
        attribute.contains(.removable) == false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions - Prefixing
    //=------------------------------------------------------------------------=
    
    @inlinable public var prefixing: Bool {
        attribute.contains(.prefixing)
    }
    
    @inlinable public var nonprefixing: Bool {
        attribute.contains(.prefixing) == false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions - Suffixing
    //=------------------------------------------------------------------------=
    
    @inlinable public var suffixing: Bool {
        attribute.contains(.suffixing)
    }
    
    @inlinable public var nonsuffixing: Bool {
        attribute.contains(.suffixing) == false
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
