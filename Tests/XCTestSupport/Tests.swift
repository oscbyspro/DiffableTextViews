//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest

//*============================================================================*
// MARK: * Tests
//*============================================================================*

/// A convenience XCTestCase class that does not continue after failure.
open class Tests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Overrides
    //=------------------------------------------------------------------------=
    
    open override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}

#endif
