//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

public struct Symbol: Equatable {
    public let attribute: Attribute
    public let character: Character
    
    // MARK: Initializers
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
    
    // MARK: Components
    
    public enum Attribute: Equatable {
        case content
        case spacer
        case prefix
        case suffix
    }
}

// MARK: - Static Initializers

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

// MARK: - Convenience Getters

public extension Symbol {
    @inlinable var content: Bool {
        attribute == .content
    }
    
    @inlinable var spacer: Bool {
        attribute == .spacer
    }
    
    @inlinable var prefix: Bool {
        attribute == .prefix
    }
    
    @inlinable var suffix: Bool {
        attribute == .suffix
    }
}
