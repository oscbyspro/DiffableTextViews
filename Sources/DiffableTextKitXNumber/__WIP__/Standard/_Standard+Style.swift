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

#warning("Rename as Standard_Style.")
//*============================================================================*
// MARK: * Style x Standard
//*============================================================================*

public struct _Style_Standard<Format>: _Style_Internal where Format: _Format_Standard {
    public typealias Value = Format.FormatInput
    public typealias Cache = _Cache_Standard<Format>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var key: _Key_Standard
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) {
        self.key = .init(locale: locale)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conformances
//=----------------------------------------------------------------------------=

extension _Style_Standard: _Style_Integer, _Style_Integer_Internal where Value: NumberTextValueXInteger { }
