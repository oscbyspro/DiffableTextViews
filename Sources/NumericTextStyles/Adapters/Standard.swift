//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//*============================================================================*
// MARK: * Standard
//*============================================================================*

public struct NumericTextNumberAdapter<Format: NumericTextNumberFormat>: Adapter {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let format: Format
    public let lexicon: Lexicon
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ format: Format) {
        self.format = format; self.lexicon = .standard(in: format.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable public func autocorrect(snapshot: inout Snapshot) { }
}
