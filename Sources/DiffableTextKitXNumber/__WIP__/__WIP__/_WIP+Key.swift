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
// MARK: * Keyable
//*============================================================================*

public protocol _Keyable {
    associatedtype Key: _Key
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(key: Key)
}

//*============================================================================*
// MARK: * Key
//*============================================================================*

public protocol _Key: Equatable {
    associatedtype Format: _Format
    
    typealias Style = _Style_WIP<Self>
    typealias Cache = _Cache_WIP<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    #warning("WIP..")
    
    @inlinable static func cache(_ style: Style) -> Cache
}


//*============================================================================*
// MARK: * Key x Standard
//*============================================================================*

public struct StandardID<Format: _Format_Standard>: _Key  {
    
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
}

//*============================================================================*
// MARK: * Key x Currency
//*============================================================================*

public struct CurrencyID<Format: _Format_Currency>: _Key {
    
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
    
    #warning("Cache does not even need to be exposed..........................")
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    #warning("Cache: DiffableTextCache where Cache.Style: Keyable, Cache.Style.Key")
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
}
