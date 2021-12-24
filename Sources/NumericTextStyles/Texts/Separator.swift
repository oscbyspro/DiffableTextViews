//
//  Separator.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-20.
//

// MARK: - Separator

@usableFromInline struct Separator: Text {
    
    // MARK: Properties
    
    @usableFromInline let characters: String
    
    // MARK: Initializers
    
    @inlinable init() {
        self.characters = ""
    }

    @inlinable init(characters: String) {
        self.characters = characters
    }
    
    // MARK: Getters
    
    @inlinable var isEmpty: Bool {
        characters.isEmpty
    }
    
    // MARK: Characters
    
    @usableFromInline static let dot: String = "."
}
