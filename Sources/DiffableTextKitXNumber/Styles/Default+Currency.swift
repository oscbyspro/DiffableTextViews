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

public struct _CurrencyStyle<Format>: _DefaultStyle, _Currency
where Format: _Format & _Currency, Format.FormatInput: _Input {
    public typealias Graph = Format.FormatInput.NumberTextGraph
    public typealias Value = Format.FormatInput
    public typealias Input = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    public var currencyCode: String
    @usableFromInline var bounds: Bounds<Input>?
    @usableFromInline var precision: Precision<Input>?
    
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
        @usableFromInline let adjustments: Label?
        
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
            assert(formatter.numberStyle == .none)
            self.interpreter = Interpreter.currency(formatter)
            //=----------------------------------=
            // Formatter x Currency
            //=----------------------------------=
            formatter.numberStyle = .currency
            self.preferences = Preferences.currency(formatter)
            //=----------------------------------=
            // Formatter x Currency x Fractionless
            //=----------------------------------=
            formatter.maximumFractionDigits = .zero
            self.adjustments = Label.currency(formatter, interpreter.components)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func compatible(_ style: Style) -> Bool {
            self.style.locale == style.locale &&
            self.style.currencyCode == style.currencyCode
        }
        
        @inlinable func snapshot(_ characters: String) -> Snapshot {
            var snapshot = Snapshot(characters,
            as: { interpreter.attributes[$0] })
            adjustments?.autocorrect(&snapshot)
            return snapshot
        }
    }
}
