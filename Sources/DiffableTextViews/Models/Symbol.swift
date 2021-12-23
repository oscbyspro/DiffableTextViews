//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

import protocol Utilities.Transformable

// MARK: Symbol

public struct Symbol: Equatable, Transformable {
    
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
        Self(character, attribute: .content)
    }
    
    @inlinable public static func prefix(_ character: Character) -> Self {
        Self(character, attribute: .prefix)
    }
    
    @inlinable public static func suffix(_ character: Character) -> Self {
        Self(character, attribute: .suffix)
    }
    
    @inlinable public static func spacer(_ character: Character) -> Self {
        Self(character, attribute: .spacer)
    }
    
    // MARK: Descriptions
    
    @inlinable public var formatting: Bool {
        attribute.contains(.formatting)
    }
    
    @inlinable public var nonformatting: Bool {
        !attribute.contains(.formatting)
    }
    
    @inlinable public var removable: Bool {
        attribute.contains(.removable)
    }
    
    @inlinable public var nonremovable: Bool {
        !attribute.contains(.removable)
    }
    
    @inlinable public var insertable: Bool {
        attribute.contains(.insertable)
    }
    
    @inlinable public var noninsertable: Bool {
        !attribute.contains(.insertable)
    }
    
    @inlinable public var prefixing: Bool {
        attribute.contains(.prefixing)
    }
    
    @inlinable public var nonprefixing: Bool {
        !attribute.contains(.prefixing)
    }
    
    @inlinable public var suffixing: Bool {
        attribute.contains(.suffixing)
    }
    
    @inlinable public var nonsuffixing: Bool {
        !attribute.contains(.suffixing)
    }
    
    // MARK: Descriptions: Utilities
    
    @inlinable public func contains(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
    
    // MARK: Transformations: Union
    
    @inlinable public mutating func formUnion(_ attribute: Attribute) {
        transform({ $0.attribute.formUnion(attribute) })
    }
    
    @inlinable public func union(_ attribute: Attribute) -> Self {
        transforming({ $0.attribute.formUnion(attribute) })
    }
    
    // MARK: Transformations: Intersection
    
    @inlinable public mutating func formIntersection(_ attribute: Attribute) {
        transform({ $0.attribute.formIntersection(attribute) })
    }
    
    @inlinable public func intersection(_ attribute: Attribute) -> Self {
        transforming({ $0.attribute.formIntersection(attribute) })
    }
}
