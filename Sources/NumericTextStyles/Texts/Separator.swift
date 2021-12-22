//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Separator

public struct Separator: Text {
    
    // MARK: Properties
    
    public let characters: String
    
    // MARK: Initializers
    
    @inlinable public init() {
        self.characters = ""
    }

    @inlinable init(characters: String) {
        self.characters = characters
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) public var isEmpty: Bool {
        characters.isEmpty
    }
    
    // MARK: Characters: Static
    
    @usableFromInline static let dot: String = "."
}
