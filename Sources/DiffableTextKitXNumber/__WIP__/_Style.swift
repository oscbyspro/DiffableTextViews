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

public struct _Style<ID: _Key>: _Protocol, _Protocol_Internal {
    public typealias Format = ID.Format
    public typealias Input = Format.FormatInput
    public typealias Value = Format.FormatInput
    public typealias Cache = ID.Cache

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var id: ID
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ id: ID) { self.id = id }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.id.locale = locale; return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    #warning("WIP..........................")
    @inlinable public func cache() -> Cache {
        ID.cache(self)
    }
    
    #warning("WIP....................................")
    @inlinable public func update(_ cache: inout Cache) {
        switch cache.style.id == id {
        case  true: cache.style = self
        case false: cache = self.cache()
        }
    }
}
