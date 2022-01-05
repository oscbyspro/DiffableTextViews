//
//  Filter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

import Utilities

//*============================================================================*
// MARK: * Filter
//*============================================================================*

@usableFromInline struct Filter {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var conditions: [(Character) -> Bool]
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.conditions = []
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func concatenate(_ condition: @escaping (Character) -> Bool) {
        conditions.append(condition)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ character: Character) throws {
        for (index, condition) in conditions.enumerated() {
            guard condition(character) else {
                throw DEBUG([.mark(character), "was invalidated by condition at index", .mark(index)])
            }
        }
    }
}
