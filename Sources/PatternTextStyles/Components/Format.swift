//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Format

@usableFromInline struct Format<Pattern> where Pattern: Collection, Pattern.Element == Character {
    
    // MARK: - Properties
    
    @usableFromInline let pattern: Pattern
    @usableFromInline let placeholder: Character
    
    // MARK: Initializers
    
    @inlinable init(pattern: Pattern, placeholder: Character) {
        self.pattern = pattern
        self.placeholder = placeholder
    }
    
    // MARK: Utilities
        
    @inlinable func capacity() -> Int {
        var count = 0; for element in pattern where element == placeholder { count += 1 }; return count
    }
    
    // MARK: Validation
    
    @inlinable func validate<C: Collection>(characters: C) throws where C.Element == Character {
        guard characters.count <= capacity() else {
            throw .cancellation(reason: "Number of characters exceeds pattern capacity.")
        }
    }
}
