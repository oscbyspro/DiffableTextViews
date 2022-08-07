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

public struct _OptionalStyle<Base>: _Style, WrapperTextStyle where
Base: _Style & NullableTextStyle, Base.Value == Base.Input {
    
    public typealias Graph = _OptionalGraph<Base.Graph>
    public typealias Cache = Base .Cache
    public typealias Value = Graph.Value
    public typealias Input = Graph.Input
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public var base: Base

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: Base) { self.base = base }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bounds: Bounds? {
        get { base.bounds }
        set { base.bounds = newValue }
    }
    
    @inlinable public var precision: Precision? {
        get { base.precision }
        set { base.precision = newValue }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Standard
//=----------------------------------------------------------------------------=

extension _OptionalStyle: _Standard where Base: _Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        get { base.locale }
        set { base.locale = newValue }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.init(Base(locale: locale))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Currency
//=----------------------------------------------------------------------------=

extension _OptionalStyle: _Currency where Base: _Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        get { base.locale }
        set { base.locale = newValue }
    }
    
    @inlinable public var currencyCode: String {
        get { base.currencyCode }
    //  set { base.currencyCode = newValue } // requires custom formats
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(code: String, locale: Locale = .autoupdatingCurrent) {
        self.init(Base(code: code, locale: locale))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Traits x Measurement(s)
//=----------------------------------------------------------------------------=

extension _OptionalStyle: _Measurement where Base: _Measurement {
    
    public typealias Unit = Base.Unit
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var unit: Unit {
        get { base.unit }
        set { base.unit = newValue }
    }
    
    @inlinable public var width: Width {
        get { base.width }
        set { base.width = newValue }
    }
    
    @inlinable public var locale: Locale {
        get { base.locale }
        set { base.locale = newValue }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unit: Unit, width: Width = .abbreviated, locale: Locale = .autoupdatingCurrent) {
        self.init(Base(unit: unit, width: width, locale: locale))
    }
}
