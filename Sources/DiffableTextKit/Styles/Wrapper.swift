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
// MARK: * Wrapper
//*============================================================================*

public protocol WrapperTextStyle: DiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Types
    //=------------------------------------------------------------------------=
    
    associatedtype Style: DiffableTextStyle
    associatedtype Value = Self.Style.Value
    associatedtype Cache = Self.Style.Cache
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @inlinable var style: Style { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension WrapperTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func locale(_ locale: Locale) -> Self {
        var result = self
        result.style = result.style.locale(locale)
        return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func cache() -> Cache
    where Cache == Style.Cache {
        style.cache()
    }
    
    @inlinable @inline(__always)
    public func update(_ cache: inout Cache)
    where Cache == Style.Cache {
        style.update(&cache)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public func format(_ value: Value, with cache: inout Cache) -> String
    where Cache == Style.Cache, Value == Style.Value {
        style.format(value, with: &cache)
    }

    @inlinable @inline(__always)
    public func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value>
    where Cache == Style.Cache, Value == Style.Value {
        style.interpret(value, with: &cache)
    }

    @inlinable @inline(__always)
    public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value>
    where Cache == Style.Cache, Value == Style.Value {
        try style.resolve(proposal, with: &cache)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}
