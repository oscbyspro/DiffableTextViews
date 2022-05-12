//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Extension
//*============================================================================*

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static func number(nines: Int) -> Self {
        guard nines != 0 else { return "0" }
        var description = nines  < 0 ? "-" : ""
        description += String(repeating: "9", count: abs(nines))
        return description
    }
}
