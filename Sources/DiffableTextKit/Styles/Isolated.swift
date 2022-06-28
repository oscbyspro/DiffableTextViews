//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Constant
//*============================================================================*

/// Stores and injects the style's cache.
///
/// Use it to take manual ownership of a style's cache.
///
@usableFromInline struct Isolated<Style: DiffableTextStyle>: WrapperTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    @usableFromInline private(set) var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ style: Style) {
        self.style = style
        self.storage = Storage(style.cache())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Value, with cache: inout Void) -> String {
        style.update(&self.storage.cache)
        return style.format(value, with: &self.storage.cache)
    }
    
    @inlinable @inline(__always)
    public func interpret(_ value: Value, with cache: inout Void) -> Commit<Style.Value> {
        style.update(&self.storage.cache)
        return style.interpret(value, with: &self.storage.cache)
    }
    
    @inlinable @inline(__always)
    public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Style.Value> {
        style.update(&self.storage.cache)
        return try style.resolve(proposal, with: &self.storage.cache)
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
        
        @inlinable @inline(__always)
        init(_ cache: Style.Cache) {
            self.cache = cache
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style
//=----------------------------------------------------------------------------=

extension DiffableTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Stores and injects the style's cache.
    ///
    /// Use it to take manual ownership of a style's cache.
    ///
    @inlinable @inline(__always)
    public func isolated() -> some DiffableTextStyle<Value> {
        Isolated(self)
    }
}
