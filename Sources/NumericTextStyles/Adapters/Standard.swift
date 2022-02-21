//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

#warning("It should cache.")
//*============================================================================*
// MARK: * Number
//*============================================================================*

final class NumericTextStandardAdapter<Format: NumericTextFormat>: Adapter {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let lexicon: Lexicon
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ format: Format) {
        self.lexicon = .standard(locale: format.locale)
    }
}
