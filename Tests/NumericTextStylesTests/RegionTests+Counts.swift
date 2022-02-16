//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import XCTest
@testable import DiffableTextViews

//*============================================================================*
// MARK: * Region x Counts
//*============================================================================*

final class RegionTestsOfCounts: XCTestCase, Earthly {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testEachLocaleMapsToARegion() {
        XCTAssertEqual(regions.count, locales.count)
    }
    
    func testThatThereAreManyRegions() {
        XCTAssertGreaterThanOrEqual(regions.count, 937)
    }
    
    func testThatThereAreManyCurrencies() {
        XCTAssertGreaterThanOrEqual(currencies.count, 153)
    }
}
