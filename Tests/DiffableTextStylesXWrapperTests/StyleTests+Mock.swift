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

//*============================================================================*
// MARK: * StyleTests x Mock
//*============================================================================*

final class StyleTestsXMock: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func test() {
        //=--------------------------------------=
        // MARK: Setup
        //=--------------------------------------=
        let mock0 = Mock(locale: en_US)
        let mock1 = mock0.locale(sv_SE)
        //=--------------------------------------=
        // MARK: Assert
        //=--------------------------------------=
        XCTAssertNotEqual(mock0, mock1)
    }
}

#endif