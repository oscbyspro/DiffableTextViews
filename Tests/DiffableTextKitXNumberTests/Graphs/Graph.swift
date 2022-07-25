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
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBounds_Decimal_Double_Int64() {
        XCTAssertEqual(Decimal.max, Decimal(string: String(repeating: "9", count: 38))!)
        XCTAssertEqual(Double .max, Double(         String(repeating: "9", count: 15))!)
        XCTAssertEqual(Int64  .max, Int64.max)
    }
    
    func testPrecision_Decimal_Double_Int64() {
        XCTAssertEqual(Decimal.precision, 38)
        XCTAssertEqual(Double .precision, 15)
        XCTAssertEqual(Int64  .precision, 19)
    }
}

#endif

