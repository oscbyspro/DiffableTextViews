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
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    @usableFromInline private(set) var shared: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ style: Style) {
        self.style = style; self.shared = Storage(style.cache())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Value, with cache: inout Void) -> String {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        style.update(&self.shared.cache)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return style.format(value, with: &self.shared.cache)
    }
    
    @inlinable @inline(__always)
    public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        style.update(&self.shared.cache)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return style.interpret(value, with: &self.shared.cache)
    }
    
    @inlinable @inline(__always)
    public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        style.update(&self.shared.cache)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return try style.resolve(proposal, with: &self.shared.cache)
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
