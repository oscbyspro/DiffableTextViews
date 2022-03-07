//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Support

//=----------------------------------------------------------------------------=
// MARK: + Placeholder
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func placeholder(_ placeholder: Character, where predicate: Predicate) -> Self {
        var result = self; result.placeholders[placeholder] = predicate; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Placeholder
//=----------------------------------------------------------------------------=

public extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// A placeholder character and a variable predicate bound to a value.
    @inlinable func placeholder<Value: Hashable>(_ character: Character,
    value: Value, where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate(proxy: value, check: predicate))
    }
    
    /// A placeholder character and a constant predicate.
    @inlinable func placeholder(_ character: Character,
    where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate(proxy: false, check: predicate))
    }
    
    /// A placeholder character and a constant predicate that always evaluates true.
    @inlinable func placeholder(_ character: Character) -> Self {
        placeholder(character, where: Predicate(proxy: false, check: { _ in true }))
    }
}
