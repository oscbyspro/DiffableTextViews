//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
import Support
import XCTest

@testable import NumericTextStyles

//=----------------------------------------------------------------------------=
// MARK: + Currency
//=----------------------------------------------------------------------------=

extension AssumptionsTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Positive
    //=------------------------------------------------------------------------=
    
    func testVirtualCurrencyCharactersDontContainNumbers() throws {
        try XCTSkipUnless(enabled)
        //=--------------------------------------=
        // MARK: Currencies, Locales
        //=--------------------------------------=
        for code in currencies {
            for locale in locales {
                let zero = IntegerFormatStyle<Int>
                .Currency(code: code, locale: locale)
                .precision(.fractionLength(0)).format(0)
                //=------------------------------=
                // MARK: Check
                //=------------------------------=
                guard zero.count(where: \.isNumber) == 1 else {
                    XCTFail("\(zero), \(locale), \(code)")
                    return
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Negative
    //=------------------------------------------------------------------------=
    
    func testVirtualCurrencyCharactersAreNotAlwaysUnique() throws {
        try XCTSkipUnless(enabled)
        let number = -1234567.89
        let currencyCode = "PAB"
        let locale = Locale(identifier: "rhg-Rohg_MM")
        let formatted = number.formatted(.currency(code: currencyCode).locale(locale))
        XCTAssertEqual(formatted, "-B/. 1,234,567.89") // currency contains a fraction separator
    }
}

#endif
