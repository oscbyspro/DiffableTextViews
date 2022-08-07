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
    
    func XCTAssertCurrencies<T: _Value>(_ value: T) where T.NumberTextGraph: _Currencyable {
        for locale in locales {
            for code in currencyCodes {
                XCTAssert(value, with: T.NumberTextGraph.Currency(code: code, locale: locale))
            }
        }
    }
        
    func XCTAssertDefaultFractionLimits(_ limits: ClosedRange<Int>, code: String) {
        typealias Style = NumberTextStyle<Decimal>.Currency
        let cache = Style(code: code, locale: .en_US_POSIX).cache()
        
        let lower = Count(digits:  1, integer:  1, fraction: limits.lowerBound)
        let upper = Count(digits: 38, integer: 38, fraction: limits.lowerBound)
        
        XCTAssertEqual(cache.precision.lower(), lower)
        XCTAssertEqual(cache.precision.upper(), upper)
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
        XCTAssertDefaultFractionLimits(0...0, code: "JPY")
        XCTAssertDefaultFractionLimits(2...2, code: "USD")
        XCTAssertDefaultFractionLimits(3...3, code: "BHD")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() {
        XCTAssertCurrencies(-1.23 as Decimal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat64_aka_Double() {
        XCTAssertCurrencies(-1.23 as Float64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() {
        XCTAssertCurrencies(-123 as Int)
    }
    
    func testInt8() {
        XCTAssertCurrencies(-123 as Int8)
    }
    
    func testInt16() {
        XCTAssertCurrencies(-123 as Int16)
    }
    
    func testInt32() {
        XCTAssertCurrencies(-123 as Int32)
    }
    
    func testInt64() {
        XCTAssertCurrencies(-123 as Int64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension StyleTestsOnCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() {
        XCTAssertCurrencies(123 as UInt)
    }
    
    func testUInt8() {
        XCTAssertCurrencies(123 as UInt8)
    }
    
    func testUInt16() {
        XCTAssertCurrencies(123 as UInt16)
    }
    
    func testUInt32() {
        XCTAssertCurrencies(123 as UInt32)
    }
    
    func testUInt64() {
        XCTAssertCurrencies(123 as UInt64)
    }
}

#endif
