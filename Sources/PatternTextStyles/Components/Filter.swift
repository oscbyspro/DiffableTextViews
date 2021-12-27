//
//  Filter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

// MARK: - Filter

@usableFromInline struct Filter {
    
    // MARK: Properties
    
    @usableFromInline var validation: ((Character) -> Bool)?
    
    // MARK: Initializers
    
    @inlinable init() {
        self.validation = nil
    }
    
    // MARK: Transformations
    
    @inlinable mutating func concatenate(_ next: @escaping (Character) -> Bool) {
        if let validation = validation {
            self.validation = { validation($0) && next($0) }
        } else {
            self.validation = next
        }
    }
    
    // MARK: Validation
    
    @inlinable func validate(_ character: Character) throws {
        if let validation = validation, !validation(character) {
            throw .cancellation(reason: "Character '\(character)' is invalid.")
        }
    }
}
