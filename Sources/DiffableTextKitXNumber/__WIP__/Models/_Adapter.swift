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
// MARK: * Adapter
//*============================================================================*

@usableFromInline struct _Adapter<Format: _Format> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline let parser: Format.Strategy
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(internal format: Format) {
        let format = format.rounded(.towardZero)
        //=--------------------------------------=
        // Instantiate
        //=--------------------------------------=
        self.format = format
        self.parser = format.locale(.en_US_POSIX).parseStrategy
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale) where Format: _Format_Standard {
        self.init(internal: Format(locale: locale))
    }
    
    @inlinable init(code: String, locale: Locale) where Format: _Format_Currency {
        self.init(internal: Format(code: code, locale: locale))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_  number: Number) throws -> Format.FormatInput {
        try parser.parse(number.description)
    }
}
