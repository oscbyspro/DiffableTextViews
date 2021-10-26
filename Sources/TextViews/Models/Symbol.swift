//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: Symbol

#warning("Rename: Attribute.Layout -> Attribute.Intuitive")
public struct Symbol: Equatable {
    
    // MARK: Properties
    
    public let character: Character
    public let attribute: Attribute
    
    // MARK: Initializers
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
    
    @inlinable public init(_ character: Character, intuitive: Attribute.Intuitive) {
        self.character = character
        self.attribute = intuitive.attribute
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func editable(_ character: Character) -> Self {
        Self(character, intuitive: .content)
    }
    
    @inlinable public static func spacer(_ character: Character) -> Self {
        Self(character, intuitive: .spacer)
    }
    
    @inlinable public static func prefix(_ character: Character) -> Self {
        Self(character, intuitive: .prefix)
    }
    
    @inlinable public static func suffix(_ character: Character) -> Self {
        Self(character, intuitive: .suffix)
    }
    
    // MARK: Descriptions
    
    @inlinable var content: Bool {
        attribute.contains(.content)
    }
    
    @inlinable var diffable: Bool {
        attribute.intersects(with: .diffableOnChange)
    }

    // MARK: Descriptions: Caret
    
    @inlinable var directsCaretForwards: Bool {
        attribute.contains(.directsCaretForwards)
    }
        
    @inlinable var directsCaretBackwards: Bool {
        attribute.contains(.directsCaretBackwards)
    }
    
    // MARK: Utilities, Static
    
    @inlinable static func predicate(intersects attribute: Attribute) -> (Self) -> Bool {
        { symbol in symbol.attribute.intersects(with: attribute) }
    }
}
