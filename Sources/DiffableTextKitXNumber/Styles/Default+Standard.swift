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

public struct _StandardStyle<Format>: _DefaultStyle, _Standard
where Format: _Format & _Standard, Format.FormatInput: _Input {
    public typealias Graph = Format.FormatInput.NumberTextGraph
    public typealias Value = Format.FormatInput
    public typealias Input = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var locale: Locale
    
    @usableFromInline var bounds: Bounds<Input>?
    @usableFromInline var precision: Precision<Input>?
    
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
        public typealias Input = Format.FormatInput
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var style:      _StandardStyle
        @usableFromInline let adapter:     Adapter<Format>
        @usableFromInline let preferences: Preferences<Input>
        @usableFromInline let interpreter: Interpreter
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ style: _StandardStyle) {
            self.style  = style
            
            self.preferences = Preferences.standard()
            self.adapter = Adapter(unchecked: Format(locale: style.locale))
            //=--------------------------------------=
            // Formatter
            //=--------------------------------------=
            let formatter = NumberFormatter()
            formatter.locale = style.locale
            //=--------------------------------------=
            // Formatter x None
            //=--------------------------------------=
            assert(formatter.numberStyle == .none)
            self.interpreter = Interpreter.standard(formatter)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func compatible(_ style: Style) -> Bool {
            self.style.locale == style.locale
        }
    }
}
