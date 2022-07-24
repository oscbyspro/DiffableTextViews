//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Isolated
//*============================================================================*

/// Stores and injects the style's cache.
///
/// Use it to take ownership of a style's cache.
///
@usableFromInline struct Isolated<Style: DiffableTextStyle>: DiffableTextStyleWrapper {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    @usableFromInline let shared: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) {
        self.style  = style; self.shared = Storage(style.cache())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        style.update(&shared.cache); return style.format(value, with: &shared.cache)
    }
    
    @inlinable public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        style.update(&shared.cache); return style.interpret(value, with: &shared.cache)
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        style.update(&shared.cache); return try style.resolve(proposal, with: &shared.cache)
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var cache: Style.Cache
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ cache: Style.Cache) {
            self.cache  = cache
        }
    }
}

//*============================================================================*
// MARK: * Isolated x Style
//*============================================================================*

extension DiffableTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Stores and injects the style's cache.
    ///
    /// Use it to take ownership of a style's cache.
    ///
    @inlinable @inline(__always)
    public func isolated() -> some DiffableTextStyle<Value> {
        Isolated(self)
    }
}
