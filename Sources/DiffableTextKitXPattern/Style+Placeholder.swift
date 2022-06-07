//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Style + Placeholder + Transformations
//*============================================================================*

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Character, Predicate
    //=------------------------------------------------------------------------=
    
    @inlinable func placeholder(_ character: Character, where predicate: Predicate) -> Self {
        var result = self; result.placeholders[character] = predicate; return result
    }

    //=------------------------------------------------------------------------=
    // MARK: Character, Closure, Proxy
    //=------------------------------------------------------------------------=
    
    /// A placeholder character and a variable predicate bound to a value.
    @inlinable public func placeholder<Value: Hashable>(_ character: Character,
    value: Value, where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate(proxy: value, check: predicate))
    }
    
    /// A placeholder character and a constant predicate.
    @inlinable public func placeholder(_ character: Character,
    where predicate: @escaping (Character) -> Bool) -> Self {
        placeholder(character, where: Predicate(proxy: _Void(), check: predicate))
    }
    
    /// A placeholder character and a constant predicate that always evaluates true.
    @inlinable public func placeholder(_ character: Character) -> Self {
        placeholder(character, where: Predicate(proxy: _Void(), check: { _ in true }))
    }
}