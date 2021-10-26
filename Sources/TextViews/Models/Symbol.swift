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
    
    // MARK: Descriptions: Editable
    
    @inlinable var editable: Bool {
        attribute.contains(.editable)
    }
    
    @inlinable var noneditable: Bool {
        !editable
    }
    
    // MARK: Descriptions: Removable

    @inlinable var removable: Bool {
        attribute.contains(.removable)
    }
    
    @inlinable var nonremovable: Bool {
        !removable
    }
    
    // MARK: Descriptions: Insertable
    
    @inlinable var insertable: Bool {
        attribute.contains(.insertable)
    }
    
    @inlinable var noninsertable: Bool {
        !insertable
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
    
    // MARK: - Descriptions: Spacer
    
    @inlinable var spacer: Bool {
        attribute.isSuperset(of: .spacer)
    }
    
    @inlinable var nonspacer: Bool {
        !spacer
    }
}
