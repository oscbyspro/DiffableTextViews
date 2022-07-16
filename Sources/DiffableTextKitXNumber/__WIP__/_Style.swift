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

#warning("WIP.................................................................")
//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct _Style<Key: _Key>: _Protocol, _Protocol_Internal {
    public typealias Format = Key.Format
    public typealias Input = Format.FormatInput
    public typealias Value = Format.FormatInput
    public typealias Cache = Key.Cache

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var key: Key
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(key: Key) { self.key = key }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.key.locale = locale; return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    #warning("WIP..........................")
    @inlinable public func cache() -> Cache {
        Key.cache(self)
    }
    
    #warning("WIP....................................")
    @inlinable public func update(_ cache: inout Cache) {
        switch cache.style.key == key {
        case  true: cache.style = self
        case false: cache = self.cache()
        }
    }
}
