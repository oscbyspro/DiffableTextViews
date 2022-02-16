//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import XCTest
@testable import NumericTextStyles

//*============================================================================*
// MARK: * LexiconTests
//*============================================================================*

final class LexiconTests: XCTestCase, Earthly {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testEachComponentIsBidirectionallyLinked() {
        func test<Component>(_ lexicon: Lexicon<Component>) {
            for component0 in Component.allCases {
                let character0 = lexicon[component0]
                let component1 = lexicon[character0]
                XCTAssertEqual(component0, component1)
            }
        }
        //=--------------------------------------=
        // MARK: Regions
        //=--------------------------------------=
        for region in regions { test(region.signs); test(region.digits); test(region.separators) }
    }
}
