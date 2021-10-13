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
}

public extension Symbol {
    // MARK: Initializers
    
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

public extension Symbol {
    // MARK: Descriptions
    
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

public extension Symbol {
    // MARK: Descriptions
    
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
