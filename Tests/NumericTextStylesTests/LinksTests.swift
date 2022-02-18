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
@testable import NumericTextStyles

//*============================================================================*
// MARK: * LinksTests
//*============================================================================*

final class LinksTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testEachComponentIsBidirectionallyLinked() {
        //=--------------------------------------=
        // MARK: One
        //=--------------------------------------=
        func one<T>(_ lexicon: Links<T>) {
            for component0 in T.allCases {
                let character0 = lexicon[component0]
                let component1 = lexicon[character0]
                XCTAssertEqual(component0, component1, String(describing: lexicon))
            }
        }
        //=--------------------------------------=
        // MARK: All
        //=--------------------------------------=
        for lexicon in standard {
            one(lexicon.signs); one(lexicon.digits); one(lexicon.separators)
        }
    }
}

#endif
