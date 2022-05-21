//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Helpers x Links
//*============================================================================*

final class HelpersTestsXLinks: XCTestCase {
    
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
        // Lexicons
        //=--------------------------------------=
        for lexicon in standards.lazy.map(\.lexicon) {
            XCTAssertEachCaseIsBidirectionallyLinked(lexicon.signs)
            XCTAssertEachCaseIsBidirectionallyLinked(lexicon.digits)
            XCTAssertEachCaseIsBidirectionallyLinked(lexicon.separators)
        }
    }
}

#endif
