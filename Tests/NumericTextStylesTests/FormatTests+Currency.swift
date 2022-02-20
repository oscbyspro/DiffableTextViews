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
// MARK: * FormatTests x Currency
//*============================================================================*

/// - There are many 144k locale-currency pairs, so it will take some time.
/// - Apple's format style cache will allocate ~100 MB per type that is tested.
final class CurrencyTests: XCTestCase, FormatTests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let tests = Set([Test.decimal])

    //*========================================================================*
    // MARK: * Test
    //*========================================================================*
    
    enum Test: CaseIterable { case decimal, double, int }
}

//=----------------------------------------------------------------------------=
// MARK: + Types
//=----------------------------------------------------------------------------=

extension CurrencyTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(tests.contains(.decimal))
        XCTInterpretLocalesXCurrencies(Decimal(string: "-1234567.89")!)
    }
        
    func testDouble() throws {
        try XCTSkipUnless(tests.contains(.double))
        XCTInterpretLocalesXCurrencies(Double("-1234567.89")!)
    }
    
    func testInt() throws {
        try XCTSkipUnless(tests.contains(.int))
        XCTInterpretLocalesXCurrencies(Int("-123456789")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocalesXCurrencies<T: Value.Currency>(_ value: T) {
        XCTInterpretLocalesXCurrencies(value, format: T.Currency.init)
    }
}

#endif
