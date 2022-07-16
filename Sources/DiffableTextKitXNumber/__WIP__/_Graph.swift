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
// MARK: * _Graph
//*============================================================================*

public protocol _Graph<Format>: Equatable {
    associatedtype Format: _Format
    typealias Parser = Format.Strategy
    
    typealias Style = _Style<Self>
    typealias Cache = _Cache<Self>
    
    typealias Input = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable static func format(_ key: Self) -> Format
    
    @inlinable static func cache(_ style: Style) -> Cache
}

//=----------------------------------------------------------------------------=
// MARK: + Branches
//=----------------------------------------------------------------------------=

public extension _Graph where Format: _Format_Percentable {
    typealias Percent = Format.Percent.NumberTextGraph
}

public extension _Graph where Format: _Format_Currencyable {
    typealias Currency = Format.Currency.NumberTextGraph
}

//*============================================================================*
// MARK: * Key x Standard
//*============================================================================*

public struct _Standard<Format: _Format_Standard>: _Graph {
    
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
    
    @inlinable public static func format(_ key: Self) -> Format {
        .init(locale: key.locale)
    }
    
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
}

//*============================================================================*
// MARK: * Key x Currency
//*============================================================================*

public struct _Currency<Format: _Format_Currency>: _Graph {
    
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
    
    @inlinable public static func format(_ key: Self) -> Format {
        .init(code: key.currencyCode, locale: key.locale)
    }
    
    @inlinable public static func cache(_ style: Style) -> Cache {
        .init(style)
    }
}
