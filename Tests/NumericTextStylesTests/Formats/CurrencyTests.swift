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

final class CurrencyTests: XCTestCase {
    typealias Format = Decimal.FormatStyle.Currency
    typealias Style = NumericTextStyle<Format>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Loops about 144k times.
    func testAllAvailableLocalesAndCurrencies() {
        let value = Decimal(string: "-1234567.89")!
        //=--------------------------------------=
        // MARK: Currencies
        //=--------------------------------------=
        for currency in currencies {
            let style = Style.currency(code: currency)
            let expectation = Format.currency(code: currency).precision(.fractionLength(0...))
            //=----------------------------------=
            // MARK: Locales
            //=----------------------------------=
            for locale in locales {
                let commit = style.locale(locale).interpret(value: value)
                let characters = expectation.locale(locale).format(value)
                //=------------------------------=
                // MARK: Value
                //=------------------------------=
                guard commit.value == value else {
                    XCTFail("\(commit.value) != \(value)... \((locale, currency))")
                    return
                }
                //=------------------------------=
                // MARK: Characters
                //=------------------------------=
                guard commit.snapshot.characters == characters else {
                    XCTFail("\(commit.snapshot.characters) != \(characters) ... \((locale, currency))")
                    return
                }
            }
        }
    }
}

#endif
