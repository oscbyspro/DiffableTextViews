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
// MARK: * DiffableTextStyle
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
    
    /// Creates and initializes a cache.
    ///
    /// - This mehotd is called on setup of a diffable text view.
    ///
    @inlinable func cache() -> Cache
    
    /// Updates the cache when before style .
    ///
    /// - This method is called before a diffable text view calls the style's main methods.
    /// - The default implementation recreates the cache by calling the cache() method.
    ///
    @inlinable func update(_ cache: inout Cache)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns formatted text.
    ///
    /// This method is called in response to changes upstream while the view is idle.
    ///
    @inlinable func format(_ value: Value, with cache: inout Cache) -> String
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to changes upstream while the view is in focus.
    ///
    @inlinable func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value>
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self { self }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func update(_ cache: inout Cache) {
        cache = self.cache()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Cache == Void
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Cache == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func cache() -> Void { () }
    
    @inlinable @inline(__always)
    public func update(_ cache: inout Void) { () }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns formatted text.
    ///
    /// This method is called in response to changes upstream while the view is idle.
    ///
    @inlinable @inline(__always)
    public func format(_ value: Value) -> String {
        var cache: Void = (); return format(value, with: &cache)
    }
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to changes upstream while the view is in focus.
    ///
    @inlinable @inline(__always)
    public func interpret(_ value: Value) -> Commit<Value> {
        var cache: Void = (); return interpret(value, with: &cache)
    }
    
    /// Returns a value and a snapshot describing it.
    ///
    /// This method is called in response to user input.
    ///
    /// - Thrown errors result in input cancellation.
    /// - Thrown errors have their descriptions printed in DEBUG mode.
    ///
    @inlinable @inline(__always)
    public func resolve(_ proposal: Proposal) throws -> Commit<Value> {
        var cache: Void = (); return try resolve(proposal, with: &cache)
    }
}
