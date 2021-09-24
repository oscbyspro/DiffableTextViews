//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

public struct Symbol {
    public let attribute: Attribute
    public let character: Character
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
}

// MARK: - Attributes

public extension Symbol {
    @inlinable static func content(_ character: Character) -> Self {
        Self(character, attribute: .content)
    }
    
    @inlinable static func spacer(_ character: Character) -> Self {
        Self(character, attribute: .spacer)
    }
    
    @inlinable static func prefix(_ character: Character) -> Self {
        Self(character, attribute: .prefix)
    }
    
    @inlinable static func suffix(_ character: Character) -> Self {
        Self(character, attribute: .suffix)
    }
}
