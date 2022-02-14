//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Combine

//*============================================================================*
// MARK: * PatternScreenContext
//*============================================================================*

final class PatternScreenContext: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let value   = Source("12345678")
    let visible = Source(true)
    let pattern = Source(Pattern.phone)

    //*========================================================================*
    // MARK: * Pattern
    //*========================================================================*
    
    enum Pattern: String, CaseIterable { case phone, card }
}
