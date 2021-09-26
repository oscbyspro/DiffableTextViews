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
    
    /// - Complexity: O(1).
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
}

// MARK: - Attributes: Initializers

public extension Symbol {
    /// - Complexity: O(1).
    @inlinable static func content(_ character: Character) -> Self {
        Self(character, attribute: .content)
    }
    
    /// - Complexity: O(1).
    @inlinable static func spacer(_ character: Character) -> Self {
        Self(character, attribute: .spacer)
    }
    
    /// - Complexity: O(1).
    @inlinable static func prefix(_ character: Character) -> Self {
        Self(character, attribute: .prefix)
    }
    
    /// - Complexity: O(1).
    @inlinable static func suffix(_ character: Character) -> Self {
        Self(character, attribute: .suffix)
    }
}

// MARK: - Attributes: Comparisons

public extension Symbol {
    /// - Complexity: O(1).
    @inlinable var content: Bool {
        attribute == .content
    }
    
    /// - Complexity: O(1).
    @inlinable var spacer: Bool {
        attribute == .spacer
    }
    
    /// - Complexity: O(1).
    @inlinable var prefix: Bool {
        attribute == .prefix
    }
    
    /// - Complexity: O(1).
    @inlinable var suffix: Bool {
        attribute == .suffix
    }
}
