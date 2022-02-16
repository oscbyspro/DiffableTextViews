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
// MARK: * Region x Assumptions
//*============================================================================*

final class RegionTestsOfAssumptions: XCTestCase, Earthly { }

//*============================================================================*
// MARK: * Region x Assumptions x Impossible
//*============================================================================*

final class RegionTestsOfImpossibleAssumptions: XCTestCase, Earthly {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testVirtualCharactersAreNotAlwaysUnique() {
        let number = -1234567.89
        let currencyCode = "PAB"
        let locale = Locale(identifier: "rhg-Rohg_MM")
        let formatted = number.formatted(.currency(code: currencyCode).locale(locale))
        XCTAssertEqual(formatted, "-B/. 1,234,567.89") // currency contains fraction separator
    }
}
