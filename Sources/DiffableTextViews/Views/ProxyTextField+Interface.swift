//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

#warning("OLD")
#warning("OLD")
#warning("OLD")
//=----------------------------------------------------------------------------=
// MARK: + Actions
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Resign
    //=------------------------------------------------------------------------=
    
    @inlinable func resign() {
        Task { @MainActor in wrapped.resignFirstResponder() }
    }
}


#endif
