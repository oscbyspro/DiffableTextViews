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
@testable import DiffableTextStylesXNumeric

//*============================================================================*
// MARK: * StyleTests x Currency
//*============================================================================*

/// - There are about 144k locale-currency pairs, so it may take a while.
final class StyleTestsXCurrency: Tests, StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocalesXCurrencies<T: Values.Currencyable>(_ value: T) {
         XCTInterpretLocalesXCurrencies(value, format: T.FormatStyle.Currency.init)
    }
    
    func XCTAssertDefaultFractionLimits(_ limits: ClosedRange<Int>, locale: Locale, code: String) {
        let style = NumericTextStyle<Decimal>.Currency(code: code, locale: locale)
        XCTAssertEqual(style.precision.lower.fraction ... style.precision.upper.fraction, limits)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Defaults
//=----------------------------------------------------------------------------=

extension StyleTestsXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDefaultFractionLimitsUSD() {
        XCTAssertDefaultFractionLimits(2...2, locale: Locale(identifier: "en_US"), code: "USD")
    }
    
    func testDefaultFractionLimitsIsSameAsCurrencyFormatter() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //=--------------------------------------=
        // MARK: Locales, Currencies
        //=--------------------------------------=
        for locale in locales {
            formatter.locale = locale
            for currencyCode in currencyCodes {
                formatter.currencyCode = currencyCode
                let limits = formatter.minimumFractionDigits...formatter.maximumFractionDigits
                XCTAssertDefaultFractionLimits(limits, locale: locale, code: currencyCode)
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsXCurrency {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        XCTInterpretLocalesXCurrencies(Decimal(string: "-1.23")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTestsXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat64_aka_Double() throws {
        XCTInterpretLocalesXCurrencies(-1.23 as Float64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension StyleTestsXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int)
    }
    
    func testInt8() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int8)
    }
    
    func testInt16() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int16)
    }
    
    func testInt32() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int32)
    }
    
    func testInt64() throws {
        XCTInterpretLocalesXCurrencies(-123 as Int64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension StyleTestsXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt)
    }
    
    func testUInt8() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt8)
    }
    
    func testUInt16() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt16)
    }
    
    func testUInt32() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt32)
    }
    
    func testUInt64() throws {
        XCTInterpretLocalesXCurrencies(123 as UInt64)
    }
}

#endif
