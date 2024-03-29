//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Standalone
//*============================================================================*

/// Grants ownership of the style's cache.
///
/// Use this modifier to control when the cache is created and destroyed.
///
public struct StandaloneTextStyle<Base: DiffableTextStyle>: WrapperTextStyle {
    
    public typealias Value = Base.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base: Base
    @usableFromInline let shared: Storage

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base) {
        self.base = base; self.shared = Storage(base.cache())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        base.update(&shared.cache); return base.format(value, with: &shared.cache)
    }
    
    @inlinable public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        base.update(&shared.cache); return base.interpret(value, with: &shared.cache)
    }
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        base.update(&shared.cache); return try base.resolve(proposal, with: &shared.cache)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }
    
    //*========================================================================*
    // MARK: * Storage [...]
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline var cache: Base.Cache
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ cache: Base.Cache) { self.cache = cache }
    }
}

//*============================================================================*
// MARK: * Standalone x Style
//*============================================================================*

public extension DiffableTextStyle {
    
    typealias Standalone = StandaloneTextStyle<Self>

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Grants ownership of the style's cache.
    ///
    /// Use this modifier to control when the cache is created and destroyed.
    ///
    @inlinable func standalone() -> Standalone {
        Standalone(self)
    }
}
