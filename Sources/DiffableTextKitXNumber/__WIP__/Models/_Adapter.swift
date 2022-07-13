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
    @usableFromInline typealias Parser = Format.Strategy
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline let parser: Parser
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    #warning("...................")
    @inlinable init(format: Format) {
        let format = format.rounded(.towardZero)
        //=--------------------------------------=
        // Instantiate
        //=--------------------------------------=
        self.format = format
        self.parser = format.locale(.en_US_POSIX).parseStrategy
    }
}
