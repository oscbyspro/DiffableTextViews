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
// MARK: * Optional x Style
//*============================================================================*

public struct _OptionalStyle<Style: _Style>:
_Style, DiffableTextStyleWrapper
where Style.Value == Style.Input {
    public typealias Graph = _OptionalGraph<Style.Graph>
    
    public typealias Cache = Style.Cache
    public typealias Value = Graph.Value
    public typealias Input = Graph.Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public var style: Style

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(_ style: Style) { self.style = style }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public func format(_ value: Value,
    with cache: inout Cache) -> String {
        value.map({ style.format($0, with: &cache) }) ?? String()
    }

    @inlinable public func interpret(_ value: Value,
    with cache: inout Cache) -> Commit<Value> {
        value.map({ Commit(style.interpret($0, with: &cache)) }) ?? Commit()
    }

    @inlinable public func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value> {
        try cache.resolve(proposal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bounds
//=----------------------------------------------------------------------------=

extension _OptionalStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Input>) -> Self {
        Self(style.bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        Self(style.bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        Self(style.bounds(limits))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Precision
//=----------------------------------------------------------------------------=

extension _OptionalStyle {

    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func precision<I>(integer: I) -> Self where
    I: RangeExpression, I.Bound == Int {
        Self(style.precision(integer: integer))
    }
    
    @inlinable public func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        Self(style.precision(fraction: fraction))
    }
    
    @inlinable public func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, F: RangeExpression, I.Bound == Int, F.Bound == Int {
        Self(style.precision(integer: integer, fraction: fraction))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Standard
//=----------------------------------------------------------------------------=

extension _OptionalStyle: _Standard where Style: _Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        style.locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.style = Style(locale: locale)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Currency
//=----------------------------------------------------------------------------=

extension _OptionalStyle: _Currency where Style: _Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        style.locale
    }
    
    @inlinable public var currencyCode: String {
        style.currencyCode
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(code: String, locale: Locale = .autoupdatingCurrent) {
        self.style = Style(code: code,   locale: locale)
    }
}
