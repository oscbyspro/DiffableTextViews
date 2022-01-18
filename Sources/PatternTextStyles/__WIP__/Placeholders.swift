//
//  Placeholders.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-18.
//

import Support

//*============================================================================*
// MARK: * Placeholders
//*============================================================================*

public struct Placeholders {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var placeholders: [Character: Predicates]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.placeholders = [:]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Predicates? {
        _read   { yield  placeholders[character] }
        _modify { yield &placeholders[character] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func contains(_ character: Character) -> Bool {
        placeholders[character] != nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func insert(_ placeholder: Placeholder) {
        placeholders[placeholder.character] = placeholder.predicates
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate<S: Sequence>(_ characters: S) throws where S.Element == Character {
        for character in characters {
            if let predicates = placeholders[character] {
                guard predicates.validate(character) else {
                    throw Info([.mark(character), "is invalid."])
                }
            }
        }        
    }
}
