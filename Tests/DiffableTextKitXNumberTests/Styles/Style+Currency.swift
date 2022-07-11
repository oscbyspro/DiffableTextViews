//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Style x Tests x Currency
//*============================================================================*

/// - There are about 300k locale-currency pairs, so it may take a while.
final class StyleTestsOnCurrency: StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocalesXCurrencies<T>(_ value: T) where
    T: NumberTextValueXCurrencyable, T == T.NumberTextValue {
         XCTInterpretLocalesXCurrencies(value, format: T.NumberTextFormat.Currency.init)
    }
    
    func XCTAssertDefaultFractionLimits(_ limits: ClosedRange<Int>, locale: Locale, code: String) {
        let style = NumberTextStyle<Decimal>.Currency(code: code, locale: locale)
        XCTAssertEqual(style.precision.fraction, limits)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Defaults
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDefaultFractionLimits_JPY_USD_BHD() {
        let locale = Locale(identifier: "en_US")
        XCTAssertDefaultFractionLimits(0...0, locale: locale, code: "JPY")
        XCTAssertDefaultFractionLimits(2...2, locale: locale, code: "USD")
        XCTAssertDefaultFractionLimits(3...3, locale: locale, code: "BHD")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        XCTInterpretLocalesXCurrencies(-1.23 as Decimal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {
    
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

extension StyleTestsOnCurrency {
    
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

extension StyleTestsOnCurrency {
    
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