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
// MARK: * Style x Optional
//*============================================================================*

public struct _OptionalStyle<Style>: _Style, WrapperTextStyle where
Style: _Style & NullableTextStyle, Style.Value == Style.Input {
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
    
    @inlinable init(_ style: Style) { self.style = style }
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
    
    @inlinable public func precision(integer:  some RangeExpression<Int>) -> Self {
        Self(style.precision(integer: integer))
    }
    
    @inlinable public func precision(fraction: some RangeExpression<Int>) -> Self {
        Self(style.precision(fraction: fraction))
    }
    
    @inlinable public func precision(
    integer:  some RangeExpression<Int>,
    fraction: some RangeExpression<Int>) -> Self {
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
        self.init(Style(locale: locale))
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
        self.init(Style(code: code, locale: locale))
    }
}
