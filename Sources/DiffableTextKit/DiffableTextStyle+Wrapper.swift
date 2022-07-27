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
    
    associatedtype Style: DiffableTextStyle
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self {
        var result = self; result.style = result.style.locale(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache == Style.Cache
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Style.Cache {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func cache() -> Cache {
        style.cache()
    }
    
    @inlinable func update(_ cache: inout Cache) {
        style.update(&cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache == Style.Cache
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Style.Cache, Value == Style.Value {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value,
    with cache: inout Cache) -> String {
        style.format(value, with: &cache)
    }
    
    @inlinable func interpret(_ value: Value,
    with cache: inout Cache) -> Commit<Value> {
        style.interpret(value, with: &cache)
    }
    
    @inlinable func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value> {
        try style.resolve(proposal, with: &cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Style: Nullable
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Self: NullableTextStyle, Style: NullableTextStyle,
Cache == Style.Cache, Value == Style.Value {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(optional value: Value?,
    with cache: inout Cache) -> String {
        style.format(optional: value, with: &cache)
    }
    
    @inlinable func interpret(optional value: Value?,
    with cache: inout Cache) -> Commit<Value?> {
        style.interpret(optional: value, with: &cache)
    }
    
    @inlinable func resolve(optional proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value?> {
        try style.resolve(optional: proposal, with: &cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Style: Nullable
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Style: NullableTextStyle,
Cache == Style.Cache, Value == Style.Value? {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value,
    with cache: inout Cache) -> String {
        style.format(optional: value, with: &cache)
    }
    
    @inlinable func interpret(_ value: Value,
    with cache: inout Cache) -> Commit<Value> {
        style.interpret(optional: value, with: &cache)
    }
    
    @inlinable func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value> {
        try style.resolve(optional: proposal, with: &cache)
    }
}
