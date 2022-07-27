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
// MARK: * Default x Style
//*============================================================================*

@usableFromInline protocol _DefaultStyle<Value>: _Style
where Cache: _DefaultCache<Self>, Value == Input {
    
    associatedtype Format: _Format
    
    typealias Input = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @inlinable var locale: Locale { get set }
    
    @inlinable var bounds: Bounds<Input>? { get set }
    
    @inlinable var precision: Precision<Input>? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _DefaultStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.locale = locale; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilitie
    //=------------------------------------------------------------------------=

    @inlinable public func cache() -> Cache {
        Cache(self)
    }
    
    @inlinable public func update(_ cache: inout Cache) {
        switch cache.compatible(self) {
        case  true: cache.style = self
        case false: cache = self.cache()
        }
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
        self.bounds(Bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        self.bounds(Bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        self.bounds(Bounds(limits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func bounds(_ bounds: Bounds<Input>) -> Self {
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
        self.precision(Precision(integer: integer))
    }
    
    @inlinable public func precision<F>(fraction: F) -> Self
    where F: RangeExpression, F.Bound == Int {
        self.precision(Precision(fraction: fraction))
    }
    
    @inlinable public func precision<I, F>(integer: I, fraction: F) -> Self
    where I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int {
        self.precision(Precision(integer: integer, fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func precision(_ precision: Precision<Input>) -> Self {
        var result = self; result.precision = precision; return result
    }
}
