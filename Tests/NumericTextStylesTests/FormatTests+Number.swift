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
// MARK: * FormatTests x Number
//*============================================================================*

final class NumberTests: XCTestCase, FormatTests {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let tests = Set(Test.allCases)
    
    //*========================================================================*
    // MARK: * Test
    //*========================================================================*
    
    enum Test: CaseIterable { case decimal, double, int }
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension NumberTests {
    
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
    
    func testInt() throws {
        try XCTSkipUnless(tests.contains(.int))
        XCTInterpretLocales(Int("-123456789")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTInterpretLocales<T: Value.Number>(_ value: T) {
        XCTInterpretLocales(value, format: T.Number.init)
    }
}

#endif
