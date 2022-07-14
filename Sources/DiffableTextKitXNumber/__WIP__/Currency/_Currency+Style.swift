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

#warning("Rename as Currency_Style.")
//*============================================================================*
// MARK: * Style x Currency
//*============================================================================*

public struct _Style_Currency<Format: _Format_Currency>: _Style_Internal {
    public typealias Value = Format.FormatInput
    public typealias Cache = _Cache_Currency<Format>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var key: _Key_Currency
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale) {
        self.key = .init(code: code, locale: locale)
    }
    
    #warning("Inspiration.....................................................")
    #warning("DiffableTextStyleWrapper where Style: _Style_Internal...........")
    //*========================================================================*
    // MARK: * Optional
    //*========================================================================*
    
    public struct Optional {
        @usableFromInline typealias Style = _Style_Currency
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let style: Style
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always) init(style: Style) { self.style = style }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conformances
//=----------------------------------------------------------------------------=

extension _Style_Currency: _Style_Integer, _Style_Integer_Internal where Value: NumberTextValueXInteger { }
