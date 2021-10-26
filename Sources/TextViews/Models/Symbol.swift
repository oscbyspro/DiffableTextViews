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
    
    // MARK: Descriptions: Real
    
    @inlinable var real: Bool {
        attribute.contains(.real)
    }
    
    @inlinable var nonreal: Bool {
        !real
    }

    // MARK: Descriptions: Diffable
    
    @inlinable var diffable: Bool {
        attribute.intersects(with: .diffableOnChange)
    }
    
    @inlinable var nondiffable: Bool {
        !diffable
    }

    // MARK: Descriptions: Forwards
    
    @inlinable var forwards: Bool {
        attribute.contains(.forwards)
    }
    
    @inlinable var nonforwards: Bool {
       !forwards
    }
    
    // MARK: Descriptions: Backwards
    
    @inlinable var backwards: Bool {
        attribute.contains(.backwards)
    }
    
    @inlinable var nonbackwards: Bool {
        !backwards
    }
}
