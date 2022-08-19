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

@usableFromInline protocol _DefaultStyle: _Style, NullableTextStyle where Cache: _DefaultCache<Self> {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _DefaultStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var S0 = self;  S0.locale = locale; return  S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public func cache() -> Cache {
        Cache(self)
    }
    
    @inlinable public func update(_ cache: inout Cache) {
        switch cache.swappable(self) {
        case  true: cache.style = self
        case false: cache = self.cache() }
    }
}

//*============================================================================*
// MARK: * Default x Cache
//*============================================================================*

@usableFromInline protocol _DefaultCache<Style>: _Cache {
    
    associatedtype Style: _DefaultStyle where Style.Input == Value
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style { get set }
    
    @inlinable var preferences: Preferences<Value> { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ style: Style)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func swappable(_ style: Style) -> Bool
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _DefaultCache {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bounds: _Bounds<Value> {
        style.bounds ?? preferences.bounds
    }
    
    @inlinable public var precision: _Precision<Value> {
        style.precision ?? preferences.precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}
