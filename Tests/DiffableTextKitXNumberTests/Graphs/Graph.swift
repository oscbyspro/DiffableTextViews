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
// MARK: * Graph x Tests
//*============================================================================*

final class GraphTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bounds
    //=------------------------------------------------------------------------=
    
    func testIntBounds() {
        XCTAssertEqual(Int._NumberTextGraph.min, Int.min)
        XCTAssertEqual(Int._NumberTextGraph.max, Int.max)
    }
    
    func testDecimalBounds() {
        let abs = Decimal(string: String(repeating: "9", count: 38))!
        XCTAssertEqual(Decimal._NumberTextGraph.min, -abs)
        XCTAssertEqual(Decimal._NumberTextGraph.max, +abs)
    }
}

#endif

