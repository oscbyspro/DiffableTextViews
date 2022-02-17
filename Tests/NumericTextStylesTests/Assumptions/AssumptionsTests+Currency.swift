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
        try skippable()
        //=--------------------------------------=
        // MARK: Currencies
        //=--------------------------------------=
        for currency in currencies {
            let style = IntegerFormatStyle<Int>
                .Currency(code: currency)
                .precision(.fractionLength(0))
            //=----------------------------------=
            // MARK: Locales
            //=----------------------------------=
            for locale in locales {
                let zero = style.locale(locale).format(0)
                //=------------------------------=
                // MARK: Failure
                //=------------------------------=
                guard zero.count(where: \.isNumber) == 1 else {
                    XCTFail("\(zero), \(locale), \(currency)")
                    return
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Negative
    //=------------------------------------------------------------------------=
    
    func testVirtualCurrencyCharactersAreNotAlwaysUnique() throws {
        try skippable()
        let number = -1234567.89
        let currencyCode = "PAB"
        let locale = Locale(identifier: "rhg-Rohg_MM")
        let formatted = number.formatted(.currency(code: currencyCode).locale(locale))
        XCTAssertEqual(formatted, "-B/. 1,234,567.89") // currency contains a fraction separator
    }
}

#endif