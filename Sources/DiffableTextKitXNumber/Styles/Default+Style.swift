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
    // MARK: Utilities
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
