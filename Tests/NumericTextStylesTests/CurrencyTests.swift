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
// MARK: * CurrencyTests
//*============================================================================*

/// - There are many 144k locale-currency pairs, so it will take some time.
/// - Apple's format style cache will allocate ~100 MB per type that is tested.
final class CurrencyTests: XCTestCase {
    
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
        XCTAssertAvailableLocaleCurrencyPairs(Decimal(string: "-1234567.89")!)
    }
        
    func testDouble() throws {
        try XCTSkipUnless(tests.contains(.double))
        XCTAssertAvailableLocaleCurrencyPairs(Double("-1234567.89")!)
    }
    
    func testInt() throws {
        try XCTSkipUnless(tests.contains(.int))
        XCTAssertAvailableLocaleCurrencyPairs(Int("-123456789")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// Iterates about 144k times.
    func XCTAssertAvailableLocaleCurrencyPairs<T: Value.Currency>(_ value: T) {
        //=--------------------------------------=
        // MARK: Currencies, Locales
        //=--------------------------------------=
        for code in currencies {
            for locale in locales {
                let style = NumericTextStyle(T.Currency(code: code, locale: locale))
                let format = style.format.precision(.fractionLength(0...))
                //=------------------------------=
                // MARK: Testables
                //=------------------------------=
                let commit = style.locale(locale).interpret(value)
                let characters = format.locale(locale).format(value)
                //=------------------------------=
                // MARK: Value
                //=------------------------------=
                guard commit.value == value else {
                    XCTFail("\(commit.value) != \(value) ... \((locale, code))")
                    return
                }
                //=------------------------------=
                // MARK: Characters
                //=------------------------------=
                guard commit.snapshot.characters == characters else {
                    XCTFail("\(commit.snapshot.characters) != \(characters) ... \((locale, code))")
                    return
                }
            }
        }
    }
}

#endif
