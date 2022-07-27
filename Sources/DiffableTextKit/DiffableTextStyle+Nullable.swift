//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Style x Nullable
//*============================================================================*

public protocol NullableTextStyle<Value>: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(optional value: Value?,
    with cache: inout Cache) -> String
    
    @inlinable func interpret(optional value: Value?,
    with cache: inout Cache) -> Commit<Value?>
    
    @inlinable func resolve(optional proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value?>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension NullableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(optional value: Value?,
    with cache: inout Cache) -> String {
        guard let value else { return "" }
        return format(value, with: &cache)
    }
    
    @inlinable func interpret(optional value: Value?,
    with cache: inout Cache) -> Commit<Value?> {
        guard let value else { return Commit() }
        return Commit(interpret(value, with: &cache))
    }
    
    @inlinable func resolve(optional proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value?> {
        //=--------------------------------------=
        // Erase
        //=--------------------------------------=
        if  proposal.replacement.isEmpty,
            proposal.range.lowerBound == proposal.base.startIndex,
            proposal.range.upperBound == proposal.base.endIndex {
            return Commit()
        //=--------------------------------------=
        // Other
        //=--------------------------------------=
        } else { return try Commit(resolve(proposal, with: &cache)) }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache == Void
//=----------------------------------------------------------------------------=

public extension NullableTextStyle where Cache == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(optional value: Value?) -> String {
        var cache: Void = (); return format(optional: value, with: &cache)
    }
    
    @inlinable func interpret(optional value: Value?) -> Commit<Value?> {
        var cache: Void = (); return interpret(optional: value, with: &cache)
    }
    
    @inlinable func resolve(optional proposal: Proposal) throws -> Commit<Value?> {
        var cache: Void = (); return try resolve(optional: proposal, with: &cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache: Style
//=----------------------------------------------------------------------------=

public extension NullableTextStyle where Cache: NullableTextStyle,
Cache.Value == Value, Cache.Cache == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(optional value: Value?,
    with cache: inout Cache) -> String {
        cache.format(optional: value)
    }
    
    @inlinable func interpret(optional value: Value?,
    with cache: inout Cache) -> Commit<Value?> {
        cache.interpret(optional: value)
    }
    
    @inlinable func resolve(optional proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value?> {
        try cache.resolve(optional: proposal)
    }
}
