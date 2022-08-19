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

public struct _StandardStyle<Format>: _DefaultStyle, _Standard where Format: _Format & _Standard {
    
    public typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    public var bounds: Bounds?
    public var precision: Precision?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    //*========================================================================*
    // MARK: * Cache
    //*========================================================================*

    public final class Cache: _DefaultCache {
        
        public typealias Value = Format.FormatInput
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var style: _StandardStyle
        @usableFromInline let preferences: Preferences<Input>

        @usableFromInline let parser: Parser<Format>
        @usableFromInline let formatter: Formatter<Format>
        @usableFromInline let interpreter: Interpreter
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ style: _StandardStyle) {
            let format = Format(locale: style.locale)
            //=----------------------------------=
            // N/A
            //=----------------------------------=
            self.style = style
            self.preferences = Preferences.standard()
            self.parser = Parser(initial: format)
            self.formatter = Formatter(initial: format)
            //=----------------------------------=
            // Formatter
            //=----------------------------------=
            let formatter = NumberFormatter()
            formatter.locale = style.locale
            //=----------------------------------=
            // Formatter x None
            //=----------------------------------=
            assert(formatter.numberStyle == .none)
            self.interpreter = Interpreter.standard(formatter)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func swappable(_ style: Style) -> Bool {
            self.style.locale == style.locale
        }
        
        @inlinable func snapshot(_ characters: String) -> Snapshot {
            Snapshot(characters, as: { interpreter.attributes[$0] })
        }
    }
}

//*============================================================================*
// MARK: * Init x Number
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64> {
    @inlinable public static var number: Self { Self() }
}

//*============================================================================*
// MARK: * Init x Number x Optional
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal?> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double?> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Int(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Int?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int8?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int16?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int32?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<Int64?> {
    @inlinable public static var number: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + UInt(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<UInt?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt8?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt16?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt32?> {
    @inlinable public static var number: Self { Self() }
}

extension DiffableTextStyle where Self == NumberTextStyle<UInt64?> {
    @inlinable public static var number: Self { Self() }
}


//*============================================================================*
// MARK: * Init x Percent
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal>.Percent {
    @inlinable public static var percent: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double>.Percent {
    @inlinable public static var percent: Self { Self() }
}

//*============================================================================*
// MARK: * Init x Percent x Optional
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Decimal [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Decimal?>.Percent {
    @inlinable public static var percent: Self { Self() }
}

//=----------------------------------------------------------------------------=
// MARK: + Float(s) [...]
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == NumberTextStyle<Double?>.Percent {
    @inlinable public static var percent: Self { Self() }
}
