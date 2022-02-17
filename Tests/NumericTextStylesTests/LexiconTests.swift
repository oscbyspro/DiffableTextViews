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
@testable import DiffableTextViews

//*============================================================================*
// MARK: * RegionTests
//*============================================================================*

final class RegionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testEachLocaleMapsToALexicon() {
        XCTAssertEqual(locales.count, lexicons.standard.count)
        XCTAssertEqual(locales.count, lexicons.currency.count)
    }
    
    func testThatThereAreManyLocalizations() {
        XCTAssertGreaterThanOrEqual(lexicons.standard.count, 937)
    }
    
    func testThatThereAreManyCurrencies() {
        XCTAssertGreaterThanOrEqual(currencies.count, 153)
    }
}

#endif