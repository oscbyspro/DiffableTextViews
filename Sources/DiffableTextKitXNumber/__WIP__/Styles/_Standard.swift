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
// MARK: * Style x Standard
//*============================================================================*

public struct _Style_Standard<Format>:
_Style_Internal_Base,
_Internal_Style_Bounds,
_Internal_Style_Precision
where Format: _Format_Standard {
    
    public typealias Value = Format.FormatInput
    public typealias Cache = _Cache_Standard<Format>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var locale: Locale
    @usableFromInline var bounds: NumberTextBounds<Value>?
    @usableFromInline var precision: NumberTextPrecision<Value>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) {
        self.locale = locale
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conformances
//=----------------------------------------------------------------------------=

extension _Style_Standard:
_Style_Precision_Integer,
_Internal_Style_Precision_Integer
where Value: NumberTextValueXInteger { }

//*============================================================================*
// MARK: * Cache x Standard
//*============================================================================*

public struct _Cache_Standard<Format>: _Cache_Internal_Base where Format: _Format_Standard {
    public typealias Style = _Style_Standard<Format>
    public typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline var adapter: _Adapter<Format>
    @usableFromInline let interpreter: NumberTextReader
    @usableFromInline let preferences: Preferences<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ style: Style) {
        self.style = style
        self.adapter = .init(locale: style.locale)
        self.preferences = .standard()
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = style.locale
        //=--------------------------------------=
        // Formatter x None
        //=--------------------------------------=
        assert(formatter.numberStyle == .none)
        self.interpreter = .standard(formatter)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating public func merge(_ style: Style) {
        //=--------------------------------------=
        // Similar
        //=--------------------------------------=
        if  self.style.locale == style.locale {
            self.style = style
        //=--------------------------------------=
        // Unique
        //=--------------------------------------=
        } else { self = Self(style) }
    }
}
