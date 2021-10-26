//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: Symbol

public struct Symbol: Equatable {
    
    // MARK: Properties
    
    public let character: Character
    public let attribute: Attribute
    
    // MARK: Initializers
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func content(_ character: Character) -> Self {
        Self(character, attribute: .content)
    }
    
    @inlinable public static func spacer(_ character: Character) -> Self {
        Self(character, attribute: .spacer)
    }
    
    @inlinable public static func prefix(_ character: Character) -> Self {
        Self(character, attribute: .prefix)
    }
    
    @inlinable public static func suffix(_ character: Character) -> Self {
        Self(character, attribute: .suffix)
    }
    
    // MARK: Descriptions
    
    @inlinable public var content: Bool {
        attribute.layout.intersects(.content)
    }
    
    #warning("Replace with some kind of curry method.")
    @inlinable public var diffable: Bool {
        attribute.differentiation.intersects(.onChange)
    }
}
