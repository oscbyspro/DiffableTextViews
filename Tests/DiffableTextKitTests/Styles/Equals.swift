//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Equals x Tests
//*============================================================================*

final class EqualsTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func test() {
        //=--------------------------------------=
        // Setup
        //=--------------------------------------=
        let mock0 = Mock(locale: en_US).equals(0)
        let mock1 = Mock(locale: sv_SE).equals(0)
        let mock2 = Mock(locale: en_US).equals(1)
        //=--------------------------------------=
        // Assert
        //=--------------------------------------=
        XCTAssertEqual(   mock0, mock1)
        XCTAssertNotEqual(mock0, mock2)
        XCTAssertNotEqual(mock1, mock2)
    }
}

#endif
