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
// MARK: * Currency x Style
//*============================================================================*

public struct _Currency_Style<Format: _Format_Currency>: _Internal_Standard {
    public typealias Cache = _Currency_Cache<Format>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var key: Cache.Key
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale) {
        self.key = .init(code: code, locale: locale)
    }}
