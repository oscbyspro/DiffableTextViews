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
@testable import DiffableTextViews

//*============================================================================*
// MARK: * HelpersTests x Direction
//*============================================================================*

final class HelpersTestsXDirection: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testReversed() {
        XCTAssertNotEqual(Direction.forwards,  Direction.forwards .reversed())
        XCTAssertNotEqual(Direction.backwards, Direction.backwards.reversed())
    }
}

#endif
