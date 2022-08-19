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
// MARK: * Style x Currency
//*============================================================================*

public struct _CurrencyStyle<Format>: _DefaultStyle, _Currency where Format: _Format & _Currency {
    
    public typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    public var currencyCode: String
    public var bounds: Bounds?
    public var precision: Precision?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(code: String, locale: Locale = .autoupdatingCurrent) {
        self.locale = locale; self.currencyCode = code
    }
    
    //*========================================================================*
    // MARK: * Cache
    //*========================================================================*
    
    public final class Cache: _DefaultCache {
        
        public typealias Value = Format.FormatInput
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var style: _CurrencyStyle
        @usableFromInline let preferences: Preferences<Input>

        @usableFromInline let parser: Parser<Format>
        @usableFromInline let formatter: Formatter<Format>
        @usableFromInline let interpreter: Interpreter
        @usableFromInline private(set) var label: Label
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ style: _CurrencyStyle) {
            let format = Format(code: style.currencyCode, locale: style.locale)
            //=----------------------------------=
            // N/A
            //=----------------------------------=
            self.style = style
            self.parser = Parser(initial: format)
            self.formatter = Formatter(initial: format)
            //=----------------------------------=
            // Formatter
            //=----------------------------------=
            let formatter = NumberFormatter()
            formatter.locale = style.locale
            formatter.currencyCode = style.currencyCode
            //=----------------------------------=
            // Formatter x None
            //=----------------------------------=
            assert(formatter.numberStyle ==  .none)
            self.interpreter = .currency(formatter)
            //=----------------------------------=
            // Formatter x Currency
            //=----------------------------------=
            formatter.numberStyle = .currency
            self.preferences = .currency(formatter)
            //=----------------------------------=
            // Formatter x Currency x Fractionless
            //=----------------------------------=
            formatter.maximumFractionDigits = .zero
            self.label = .currency(formatter)
            self.label.virtual = label.text.allSatisfy(interpreter.components.virtual)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func swappable(_ style: Style) -> Bool {
            self.style.locale == style.locale &&
            self.style.currencyCode  == style.currencyCode
        }
        
        @inlinable func snapshot(_  characters: String) -> Snapshot {
            var snapshot = Snapshot(characters, /*-----*/
            as: { interpreter.attributes[$0] }) /*-----*/
            label.autocorrect(&snapshot); return snapshot
        }
    }
}

//*============================================================================*
// MARK: * Init x Currency
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//*============================================================================*
// MARK: * Init x Currency x Optional
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64?>.Currency {
    @inlinable public static func currency(code: String) -> Self { Self(code: code) }
}
