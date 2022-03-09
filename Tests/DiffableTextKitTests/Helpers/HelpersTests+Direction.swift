//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit
@testable import DiffableTextKit

//*============================================================================*
// MARK: * HelpersTests x Direction
//*============================================================================*

final class HelpersTests_Direction: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testReversed() {
        XCTAssertEqual(Direction .forwards.reversed(), .backwards)
        XCTAssertEqual(Direction.backwards.reversed(),  .forwards)
    }
}

#endif
