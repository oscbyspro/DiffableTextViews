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
// MARK: * HelpersTests x Links
//*============================================================================*

final class HelpersTestsXLinks: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertEachCaseIsBidirectionallyLinked<T>(_ links: Links<T>) {
        for component in T.allCases {
            XCTAssertEqual(component, links[links[component]])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testEachLexiconIsFullyBidirectionallyLinked() {
        //=--------------------------------------=
        // MARK: Lexicons
        //=--------------------------------------=
        for lexicon in standard {
            XCTAssertEachCaseIsBidirectionallyLinked(lexicon.signs)
            XCTAssertEachCaseIsBidirectionallyLinked(lexicon.digits)
            XCTAssertEachCaseIsBidirectionallyLinked(lexicon.separators)
        }
    }
}

#endif
