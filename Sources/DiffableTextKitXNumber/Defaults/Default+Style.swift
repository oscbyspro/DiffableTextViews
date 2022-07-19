//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct _DefaultStyle<ID: _DefaultID>: _Style {
    public typealias Graph = ID.Graph
    public typealias Cache = ID.Cache
    public typealias Input = ID.Input
    public typealias Value = ID.Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var id: ID
    @usableFromInline var bounds: _Bounds<Input>?
    @usableFromInline var precision: _Precision<Input>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(code:String,
    locale: Locale = .autoupdatingCurrent)
    where ID == _CurrencyID<T> {
        self.id = ID(code: code, locale: locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.id.locale = locale; return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func cache() -> Cache {
        ID.cache(self)
    }
    
    @inlinable public func update(_ cache: inout Cache) {
        switch cache.style.id == id {
        case  true: cache.style = self
        case false: cache = self.cache() }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value,
    with cache: inout Cache) -> String {
        cache.format(value)
    }
    
    @inlinable public func interpret(_ value: Value,
    with cache: inout Cache) -> Commit<Value> {
        cache.interpret(value)
    }
    
    @inlinable public func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value> {
        try cache.resolve(proposal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bounds
//=----------------------------------------------------------------------------=

extension _DefaultStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Input>) -> Self {
        self.bounds(.init(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        self.bounds(.init(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        self.bounds(.init(limits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func bounds(_ bounds: _Bounds<Input>) -> Self {
        var result = self; result.bounds = bounds; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Precision
//=----------------------------------------------------------------------------=

extension _DefaultStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(integer: I) -> Self
    where I: RangeExpression, I.Bound == Int {
        self.precision(.init(integer: integer))
    }
    
    @inlinable public func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        self.precision(.init(fraction: fraction))
    }
    
    @inlinable public func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int {
        self.precision(.init(integer: integer, fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision(_ precision: _Precision<Input>) -> Self {
        var result = self; result.precision = precision; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Standard
//=----------------------------------------------------------------------------=

extension _DefaultStyle: _Standard where ID: _Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        id.locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.id = ID(locale: locale)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Currency
//=----------------------------------------------------------------------------=

extension _DefaultStyle: _Currency where ID: _Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        id.locale
    }
    
    @inlinable public var currencyCode: String {
        id.currencyCode
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(code: String, locale: Locale = .autoupdatingCurrent) {
        self.id = ID(code: code, locale: locale)
    }
}
