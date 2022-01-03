//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-27.
//

import Quick

//*============================================================================*
// MARK: * Format
//*============================================================================*

@usableFromInline struct Format<Pattern> where Pattern: Collection, Pattern.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: Pattern
    @usableFromInline let placeholder: Character
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(pattern: Pattern, placeholder: Character) {
        self.pattern = pattern
        self.placeholder = placeholder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate<C: Collection>(characters: C) throws where C.Element == Character {
        let capacity = pattern.reduce(into: 0) { count, _ in count += 1 }

        guard characters.count <= capacity else {
            throw Redacted.mark(characters).text("exceeded pattern capacity").mark(capacity)
        }
    }
}
