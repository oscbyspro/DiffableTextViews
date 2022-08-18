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

public struct _StandardStyle<Format>: _Default, _Standard where Format: _Format & _Standard {
    
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

    public final class Cache: _Cache {
        
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
        
        @inlinable func merge(_ style: Style) -> Bool {
            let merge = self.style.locale  == style.locale
            if  merge { self.style = style }; return merge
        }
        
        @inlinable func snapshot(_ characters: String) -> Snapshot {
            Snapshot(characters, as: { interpreter.attributes[$0] })
        }
    }
}
