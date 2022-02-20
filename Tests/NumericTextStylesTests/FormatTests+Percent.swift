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

    //*========================================================================*
    // MARK: * Test
    //*========================================================================*
    
    enum Test: CaseIterable { case decimal, double }
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension PercentTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(tests.contains(.decimal))
        XCTInterpretLocales(Decimal(string: "-1234567.89")!)
    }
        
    func testDouble() throws {
        try XCTSkipUnless(tests.contains(.double))
        XCTInterpretLocales(Double("-1234567.89")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocales<T: Value.Percent>(_ value: T) {
        XCTInterpretLocales(value, format: T.Percent.init)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Restrictions
//=----------------------------------------------------------------------------=

extension PercentTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(Float16("1.23")!, result: "123.046875%")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(Float32("1.23")!, result: "123.000002%")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func XCTAssert<T: Value.Percent>(_ value: T, result: String) {
        XCTAssertEqual(T.Percent(locale: en_US).format(value), result)
    }
}

#endif
