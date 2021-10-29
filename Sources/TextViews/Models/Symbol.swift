//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

// MARK: Symbol

public struct Symbol: Equatable {
    
    // MARK: Properties
    
    public var character: Character
    public var attribute: Attribute
    
    // MARK: Initializers
    
    @inlinable public init(_ character: Character, attribute: Attribute) {
        self.character = character
        self.attribute = attribute
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func content(_ character: Character) -> Self {
        Self(character, attribute: .intuitive(.content))
    }
    
    @inlinable public static func prefix(_ character: Character) -> Self {
        Self(character, attribute: .intuitive(.prefix))
    }
    
    @inlinable public static func suffix(_ character: Character) -> Self {
        Self(character, attribute: .intuitive(.suffix))
    }
    
    @inlinable public static func spacer(_ character: Character) -> Self {
        Self(character, attribute: .intuitive(.spacer))
    }
    
    // MARK: Descriptions
    
    @inlinable public var content: Bool {
        !attribute.contains(.format)
    }
    
    // MARK: Transformations
    
    @inlinable public func union(_ attribute: Attribute) -> Self {
        update({ $0.attribute.formUnion(attribute) })
    }
    
    @inlinable public func intersection(_ attribute: Attribute) -> Self {
        update({ $0.attribute.formIntersection(attribute) })
    }
    
    @inlinable public func update(_ transform: (inout Self) -> Void) -> Self {
        var result = self; transform(&result); return result
    }
}
