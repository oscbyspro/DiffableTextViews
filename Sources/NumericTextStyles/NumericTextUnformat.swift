//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: Table of Contents
//=----------------------------------------------------------------------------=

@usableFromInline typealias Unformat = NumericTextUnformat

//*============================================================================*
// MARK: * Unformat
//*============================================================================*

public protocol NumericTextUnformat {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func unformat(snapshot: inout Snapshot)
}
