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
@testable import DiffableTextStylesXWrapper

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class StyleTestsXEquals: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func test() {
        //=--------------------------------------=
        // MARK: Setup
        //=--------------------------------------=
        let mock0 = Mock(locale: en_US).equals(0)
        let mock1 = Mock(locale: sv_SE).equals(0)
        let mock2 = Mock(locale: en_US).equals(1)
        //=--------------------------------------=
        // MARK: Assert
        //=--------------------------------------=
        XCTAssertEqual(   mock0, mock1)
        XCTAssertNotEqual(mock0, mock2)
        XCTAssertNotEqual(mock1, mock2)
    }
}

#endif
