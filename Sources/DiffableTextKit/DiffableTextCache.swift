//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Cache
//*============================================================================*

public protocol DiffableTextCache {
    associatedtype Style: DiffableTextStyle
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns formatted text.
    ///
    /// This method is called in response to changes upstream while the view is idle.
    ///
    @inlinable func format(_ value: Style.Value) -> String
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to changes upstream while the view is in focus.
    ///
    @inlinable func interpret(_ value: Style.Value) -> Commit<Style.Value>
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable func resolve(_ proposal: Proposal) throws -> Commit<Style.Value>
}

//*============================================================================*
// MARK: * Cache x Style
//*============================================================================*

public extension DiffableTextStyle where Cache: DiffableTextCache, Cache.Style == Self {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value, with cache: inout Cache) -> String {
        cache.format(value)
    }
    
    @inlinable func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        cache.interpret(value)
    }
    
    @inlinable func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try cache.resolve(proposal)
    }
}
