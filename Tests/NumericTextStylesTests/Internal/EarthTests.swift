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

//*============================================================================*
// MARK: * EarthTests
//*============================================================================*

final class EarthTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testThatThereAreManyLocales() {
        XCTAssertGreaterThanOrEqual(locales.count, 937)
    }
    
    func testThatThereAreManyCurrencyCodes() {
        XCTAssertGreaterThanOrEqual(currencyCodes.count, 153)
    }
}

#endif
