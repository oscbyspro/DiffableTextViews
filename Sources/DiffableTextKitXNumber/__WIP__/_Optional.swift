//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Optional
//*============================================================================*

public struct _Optional<Style: _Style>: DiffableTextStyleWrapper, _Style where Style.Value == Style.Input {
    public typealias Cache = Style.Cache
    public typealias Value = Style.Value?
    public typealias Input = Style.Value
    
    //=-------------------------------------------------------------------------=
    // MARK: State
    //=-------------------------------------------------------------------------=

    public var style: Style

    //=-------------------------------------------------------------------------=
    // MARK: Initializers
    //=-------------------------------------------------------------------------=

    @inlinable @inline(__always) init(_ style: Style) { self.style = style }
    
    //=-------------------------------------------------------------------------=
    // MARK: Utilities
    //=-------------------------------------------------------------------------=

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
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension _Optional {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    public func bounds(_ limits: ClosedRange<Input>) -> Self {
        Self(style.bounds(limits))
    }
    
    public func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        Self(style.bounds(limits))
    }
    
    public func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        Self(style.bounds(limits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    public func precision<I>(integer: I) -> Self where
    I: RangeExpression, I.Bound == Int {
        Self(style.precision(integer: integer))
    }
    
    public func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        Self(style.precision(fraction: fraction))
    }
    
    public func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, F: RangeExpression, I.Bound == Int, F.Bound == Int {
        Self(style.precision(integer: integer, fraction: fraction))
    }
}
