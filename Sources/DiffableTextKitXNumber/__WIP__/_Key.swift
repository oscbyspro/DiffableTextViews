//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

#warning("Key-Format relationship is reversed, maybe..........................")
//*============================================================================*
// MARK: * Key
//*============================================================================*

public protocol _Key<Format>: Equatable {
    associatedtype Format: _Format
    typealias Style = _Style<Self>
    typealias Cache = _Cache<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format() -> Format
    
    @inlinable static func cache(_ style: Style) -> Cache
}

//*============================================================================*
// MARK: * Key x Standard
//*============================================================================*

public struct _StandardID<Format: _Format_Standard>: _Key {
    
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
    
    @inlinable public func format() -> Format {
        .init(locale: locale)
    }
    
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
}

//*============================================================================*
// MARK: * Key x Currency
//*============================================================================*

public struct _CurrencyID<Format: _Format_Currency>: _Key {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    public var currencyCode: String

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale) {
        self.locale = locale
        self.currencyCode = code
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func format() -> Format {
        .init(code: currencyCode, locale: locale)
    }
    
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
}
