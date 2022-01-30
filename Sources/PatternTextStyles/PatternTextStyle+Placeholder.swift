//
//  PatternTextStyle+Placeholder.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-30.
//

import Support

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Placeholder
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func placeholder(_ character: Character, where predicate: Predicate) -> Self {
        var result = self; result.placeholders[character] = predicate; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Placeholder - Public
//=----------------------------------------------------------------------------=

public extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// A placeholder character and a constant predicate that always evaluates true.
    @inlinable func placeholder(_ character: Character) -> Self {
        placeholder(character, where: Predicate(proxy: Constant(), check: { _ in true }))
    }
    
    /// A placeholder character and a constant predicate.
    @inlinable func placeholder(_ character: Character,
        where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate(proxy: Constant(), check: predicate))
    }
    
    /// A placeholder character and a variable predicate bound to a value.
    @inlinable func placeholder<Value: Hashable>(_ character: Character,
        value: Value, where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate(proxy: Constant(), check: predicate))
    }
}
