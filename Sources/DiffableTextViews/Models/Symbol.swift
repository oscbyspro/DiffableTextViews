//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

//*============================================================================*
// MARK: * Symbol
//*============================================================================*

/// A character and an attribute describing its behavior.
public struct Symbol: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    /// A standard space symbol: U+0020.
    public static let spacer = Self(
        character: "\u{0020}",
        attribute: .phantom
    )
    
    /// A zero-width space symbol: U+200B, that is non-passthrough.
    public static let anchor = Self(
        character: "\u{200B}",
        attribute: .phantom.subtracting(.passthrough)
    )
        
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
    
    @inlinable public init(_ character: Character, as attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public static func content(_ character: Character) -> Self {
        Self(character, as: .content)
    }
    
    @inlinable @inline(__always) public static func phantom(_ character: Character) -> Self {
        Self(character, as: .phantom)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func contains(_ character: Character) -> Bool {
        self.character == character
    }

    @inlinable @inline(__always) public func contains(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors - Virtual
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public var virtual: Bool {
        self.attribute.contains(.virtual)
    }
    
    @inlinable @inline(__always) public var nonvirtual: Bool {
        self.attribute.contains(.virtual) == false
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
