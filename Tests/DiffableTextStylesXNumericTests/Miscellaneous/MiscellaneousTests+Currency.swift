//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit

//*============================================================================*
// MARK: * MiscellaneousTests x Currency
//*============================================================================*

final class MiscellaneousTests_Currency: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: Positive
    //=------------------------------------------------------------------------=
    
    func testCurrencyLabelDoesNotContainNumbers() throws {
        //=--------------------------------------=
        // MARK: Locales, Currencies
        //=--------------------------------------=
        for locale in locales {
            for code in currencyCodes {
                let zero = 0.formatted(.currency(code: code).locale(locale).precision(.fractionLength(0)))
                XCTAssert(zero.count(where: \.isNumber) == 1, "\(zero), \(locale), \(code)")
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Negative
    //=------------------------------------------------------------------------=
    
    func testCurrencyLabelIsSometimesReal() throws {
        let number = -1234567.89
        let currencyCode = "PAB"
        let locale = Locale(identifier: "rhg-Rohg_MM")
        let formatted = number.formatted(.currency(code: currencyCode).locale(locale))
        XCTAssertEqual(formatted, "-B/. 1,234,567.89") // currency contains a fraction separator
    }
}

#endif
