//
//  Placeholder.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-18.
//

//*============================================================================*
// MARK: * Placeholder
//*============================================================================*

public struct Placeholder {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let character: Character
    @usableFromInline var predicates: Predicates
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(character: Character) {
        self.character = character
        self.predicates = Predicates()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func predicate(_ predicate: Predicates) -> Self {
        var result = self
        result.predicates.insert(predicate)
        return result
    }
}
