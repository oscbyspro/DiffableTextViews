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
    
    @usableFromInline var storage: [Character: Predicate]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.storage = [:]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Subscripts
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(character: Character) -> Predicate? {
        _read   { yield  storage[character] }
        _modify { yield &storage[character] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func contains(_ character: Character) -> Bool {
        storage[character] != nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func insert(_ character: Character, where predicate: Predicate) {
        storage[character] = predicate
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    #warning("Maybe snapshot should throw instead.")
    @inlinable func validate<S: Sequence>(_ characters: S) throws where S.Element == Character {
        for character in characters {
            print(storage)
            if let predicate = storage[character] {
                print(character)
                try predicate.validate(character)
            }
        }
    }
}
