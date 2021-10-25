//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: Symbol

public struct Symbol: Equatable {
    
    // MARK: Properties
    
    public let attribute: Attribute
    public let character: Character
    
    // MARK: Initializers
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
    
    // MARK: Initializers: Static
    
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
    
    // MARK: Descriptions: Positive
    
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

    // MARK: Descriptions: Negative
    
    @inlinable var noncontent: Bool {
        attribute != .content
    }
    
    @inlinable var nonspacer: Bool {
        attribute != .spacer
    }
    
    @inlinable var nonprefix: Bool {
        attribute != .prefix
    }
    
    @inlinable var nonsuffix: Bool {
        attribute != .suffix
    }
}
