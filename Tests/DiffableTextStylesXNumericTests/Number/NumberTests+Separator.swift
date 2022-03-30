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
@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * NumberTests x Separator
//*============================================================================*

final class NumberTestsXSeparator: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertASCII(_ separator: Separator, _ character: Character) {
         XCTAssertEqual(separator.character, character)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testASCII() {
        XCTAssertASCII(.fraction, ".")
        XCTAssertASCII(.grouping, ",")
    }
}

#endif
