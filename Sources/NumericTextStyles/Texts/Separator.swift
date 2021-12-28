//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

#warning("Rework.")

// MARK: - Separator

/// A representation of system separator.
@usableFromInline struct Separator: Text {
    
    // MARK: Properties
    
    @usableFromInline var characters: String = ""
    
    // MARK: Initializers
    
    @inlinable init() { }
    
    // MARK: Getters
    
    @inlinable var isEmpty: Bool {
        characters.isEmpty
    }
    
    // MARK: Transformations
    
    @inlinable mutating func append(_ element: Character) {
        characters.append(element)
    }
    
    @inlinable mutating func append(contentsOf elements: String) {
        characters.append(contentsOf: elements)
    }
    
    // MARK: Characters
    
    @usableFromInline static let dot: String = "."
}
