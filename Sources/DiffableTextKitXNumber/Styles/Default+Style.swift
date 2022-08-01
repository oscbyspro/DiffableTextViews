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

@usableFromInline protocol _DefaultStyle<Value>: _Style, NullableTextStyle
where Cache: _DefaultCache<Self>, Value == Input, Input: _Input {
    
    associatedtype Format: _Format
    
    typealias Input = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
        
    @inlinable var locale: Locale { get set }
    
    @inlinable var bounds: Bounds<Value>? { get set }
    
    @inlinable var precision: Precision<Value>? { get set }
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
        case false: cache = self.cache() }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bounds
//=----------------------------------------------------------------------------=

extension _DefaultStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Value>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Value>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Value>) -> Self {
        bounds(Bounds(limits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: Bounds<Value>) -> Self {
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
    
    @inlinable public func precision(_ digits: some RangeExpression<Int>) -> Self {
        precision(Precision(digits))
    }
    
    @inlinable public func precision(integer:  some RangeExpression<Int>) -> Self {
        precision(Precision(integer: integer))
    }
    
    @inlinable public func precision(fraction: some RangeExpression<Int>) -> Self {
        precision(Precision(fraction: fraction))
    }
    
    @inlinable public func precision(
    integer:  some RangeExpression<Int>,
    fraction: some RangeExpression<Int>) -> Self {
        precision(Precision(integer: integer, fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision<Value>) -> Self {
        var result = self; result.precision = precision; return result
    }
}
