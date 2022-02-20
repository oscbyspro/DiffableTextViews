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
// MARK: * FormatTests x Percent
//*============================================================================*

final class PercentTests: XCTestCase, FormatTests {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let tests = Set(Test.allCases)
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocales<T: Value.Percent>(_ value: T) {
         XCTInterpretLocales(value, format: T.Percent.init)
    }
    
    func XCTAssert<T: Value.Percent>(_ value: T, result: String) {
         XCTAssert(value, format: T.Percent(locale: en_US), result: result)
    }

    //*========================================================================*
    // MARK: * Test
    //*========================================================================*
    
    enum Test: CaseIterable {
        case decimal
        case float64
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension PercentTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(tests.contains(.decimal))
        XCTInterpretLocales(Decimal(string: "-1234567.89")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension PercentTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testDouble() throws {
        try XCTSkipUnless(tests.contains(.float64))
        XCTInterpretLocales(Float64("-1234567.89")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Inaccurate
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(Float16("1.23")!, result: "123.046875%")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(Float32("1.23")!, result: "123.00000190734863%")
    }
}

#endif
