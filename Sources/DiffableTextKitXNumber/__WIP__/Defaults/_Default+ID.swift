//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * ID
//*============================================================================*

public protocol _DefaultID<Format>: Equatable {
    associatedtype Format: _Format
    typealias Input = Format.FormatInput
    typealias Graph = Input.NumberTextGraph

    typealias Style = _DefaultStyle<Self>
    typealias Cache = _DefaultCache<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func cache(_ style: Style) -> Cache
    
    @inlinable static func format(_ instance: Self) -> Format
}

//*============================================================================*
// MARK: * ID x Standard
//*============================================================================*

public struct _StandardID<Format: _Format_Standard>: _DefaultID {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) {
        self.locale = locale
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
    
    @inlinable public static func format(_ instance: Self) -> Format {
        .init(locale: instance.locale)
    }
}

//*============================================================================*
// MARK: * ID x Currency
//*============================================================================*

public struct _CurrencyID<Format: _Format_Currency>: _DefaultID {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    public var currencyCode: String

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale) {
        self.locale = locale; self.currencyCode = code
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
    
    @inlinable public static func format(_ instance: Self) -> Format {
        .init(code: instance.currencyCode, locale: instance.locale)
    }
}
