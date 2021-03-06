//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Range
//*============================================================================*

extension ClosedRange where Bound: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ unordered: (Bound, Bound)) {
        switch unordered.0 <= unordered.1 {
        case  true: self.init(uncheckedBounds: (unordered.0, unordered.1))
        case false: self.init(uncheckedBounds: (unordered.1, unordered.0))
        }
    }
}
