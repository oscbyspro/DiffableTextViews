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
// MARK: * Miscellaneous x Currency
//*============================================================================*

final class MiscellaneousTestsXCurrency: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCurrencyLabelsAreSometimesReal() throws {
        let number = -1234567.89
        let currencyCode = "PAB"
        let locale = Locale(identifier: "rhg-Rohg_MM")
        let formatted = number.formatted(.currency(code: currencyCode).locale(locale))
        XCTAssertEqual(formatted, "-B/. 1,234,567.89") // currency contains a fraction separator
    }
    
    func testCurrencyLabelsDoNotContainNumbers() throws {
        //=--------------------------------------=
        // Locales, Currencies
        //=--------------------------------------=
        for locale in locales {
            for code in currencyCodes {
                let zero = 0.formatted(.currency(code: code).locale(locale).precision(.fractionLength(0)))
                XCTAssert(zero.count(where: \.isNumber) == 1, "\(zero), \(locale), \(code)")
            }
        }
    }
}

#endif
