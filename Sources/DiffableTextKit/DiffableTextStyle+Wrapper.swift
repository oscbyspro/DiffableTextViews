//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Style x Wrapper
//*============================================================================*

public protocol WrapperTextStyle: DiffableTextStyle {
    
    associatedtype Base: DiffableTextStyle
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @inlinable var base: Base { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self {
        var S0 = self; S0.base = S0.base.locale(locale); return S0
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache == Base.Cache
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Base.Cache {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func cache() -> Cache {
        base.cache()
    }
    
    @inlinable func update(_ cache: inout Cache) {
        base.update(&cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache == Base.Cache
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Base.Cache, Value == Base.Value {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value, with cache: inout Cache) -> String {
        base.format(value, with: &cache)
    }
    
    @inlinable func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        base.interpret(value, with: &cache)
    }
    
    @inlinable func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try base.resolve(proposal, with: &cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Base: Nullable
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Base.Cache, Value == Base.Value?, Base: NullableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value, with cache: inout Cache) -> String {
        base.format(optional: value, with: &cache)
    }
    
    @inlinable func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        base.interpret(optional: value, with: &cache)
    }
    
    @inlinable func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try base.resolve(optional: proposal, with: &cache)
    }
}
