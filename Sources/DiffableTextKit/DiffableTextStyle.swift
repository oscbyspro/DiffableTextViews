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
// MARK: * Style
//*============================================================================*

/// A protocol for styles capable of as-you-type formatting.
public protocol DiffableTextStyle<Value>: Equatable {

    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    associatedtype Cache = Void
    associatedtype Value: Equatable

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Updates the locale, if possible.
    ///
    /// - The locale may be overriden by the environment.
    /// - The default implementation returns an unmodified self.
    ///
    @inlinable func locale(_ locale: Locale) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns a cache.
    ///
    /// - This method is called on setup of a diffable text view.
    ///
    @inlinable func cache() -> Cache
    
    /// Updates the cache.
    ///
    /// - The default implementation recreates the cache with the cache() method.
    ///
    @inlinable func update(_ cache: inout Cache)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns formatted text.
    ///
    /// This method is called in response to changes upstream while the view is idle.
    ///
    @inlinable func format(_ value: Value,
    with cache: inout Cache) -> String
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to changes upstream while the view is in focus.
    ///
    @inlinable func interpret(_ value: Value,
    with cache: inout Cache) -> Commit<Value>
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func locale(_ locale: Locale) -> Self { self }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func update(_ cache: inout Cache) { cache = self.cache() }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache == Void
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle where Cache == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func cache() -> Void { }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value) -> String {
        var cache: Void = (); return format(value, with: &cache)
    }
    
    @inlinable func interpret(_ value: Value) -> Commit<Value> {
        var cache: Void = (); return interpret(value, with: &cache)
    }
    
    @inlinable func resolve(_ proposal: Proposal) throws -> Commit<Value> {
        var cache: Void = (); return try resolve(proposal, with: &cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Cache: DiffableTextStyle
//=----------------------------------------------------------------------------=

public extension DiffableTextStyle where Cache: DiffableTextStyle,
Cache.Value == Value, Cache.Cache == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value,
    with cache: inout Cache) -> String {
        cache.format(value)
    }
    
    @inlinable func interpret(_ value: Value,
    with cache: inout Cache) -> Commit<Value> {
        cache.interpret(value)
    }
    
    @inlinable func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value> {
        try cache.resolve(proposal)
    }
}
