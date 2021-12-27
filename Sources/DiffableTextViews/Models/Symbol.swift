//
//  Symbol.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

import protocol Utilities.Transformable

// MARK: - Symbol

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
    
    // MARK: Predicates
    
    @inlinable public func `is`(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }
    
    @inlinable public func `is`(non attribute: Attribute) -> Bool {
        !self.attribute.contains(attribute)
    }
    
    // MARK: Predicates: Static
    
    @inlinable public static func `is`(_ attribute: Attribute) -> (Self) -> Bool {{
        $0.is(attribute)
    }}
    
    @inlinable public static func `is`(non attribute: Attribute) -> (Self) -> Bool {{
        $0.is(non: attribute)
    }}
}

// MARK: - Symbol: Descriptions

extension Symbol: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: Implementation
    
    public var description: String {
        String(character)
    }
    
    public var debugDescription: String {
        "(\(character), \(attribute))"
    }
}
