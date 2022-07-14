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
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style.Cache
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Style.Cache {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func cache() -> Cache {
        style.cache()
    }
    
    @inlinable @inline(__always)
    func update(_ cache: inout Cache) {
        style.update(&cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style.Cache, Style.Value
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Style.Cache, Value == Style.Value {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func format(_ value: Value, with cache: inout Cache) -> String {
        style.format(value, with: &cache)
    }
    
    @inlinable @inline(__always)
    func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        style.interpret(value, with: &cache)
    }
    
    @inlinable @inline(__always)
    func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try style.resolve(proposal, with: &cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Style.Cache, Style.Value?
//=----------------------------------------------------------------------------=

public extension WrapperTextStyle where Cache == Style.Cache, Value == Style.Value? {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func format(_ value: Value, with cache: inout Cache) -> String {
        value.map({ style.format($0, with: &cache) }) ?? String()
    }
    
    @inlinable @inline(__always)
    func interpret(_ value: Value, with cache: inout Cache) -> Commit<Value> {
        value.map({ Commit(style.interpret($0, with: &cache)) }) ?? Commit()
    }
    
    @inlinable @inline(__always)
    func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Value> {
        let nonoptional = try style.resolve(proposal, with: &cache)
        return !nonoptional.snapshot.isEmpty ?  Commit(nonoptional) : Commit()
    }
}
