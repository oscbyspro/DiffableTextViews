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
// MARK: * Content
//*============================================================================*

@usableFromInline typealias Specialization = NumericTextSpecialization

//*============================================================================*
// MARK: * Adapter
//*============================================================================*

#warning("Rename as specialization, maybe.")
public protocol NumericTextSpecialization {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var lexicon: Lexicon { get }

    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ snapshot: inout Snapshot)
}

