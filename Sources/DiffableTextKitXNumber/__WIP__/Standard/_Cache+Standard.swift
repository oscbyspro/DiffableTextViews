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
// MARK: * Cache x Standard
//*============================================================================*

public struct _Cache_Standard<Format>: _Cache_Internal_Base where Format: _Format {
    public typealias Style = _Style_Standard<Format>
    public typealias Value = Format.FormatInput
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let interpreter: NumberTextReader
    @usableFromInline let preferences: Preferences<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) {
        self.style = style
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
}
