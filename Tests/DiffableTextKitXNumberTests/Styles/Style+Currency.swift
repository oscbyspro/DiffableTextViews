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
        XCTAssertCurrencies(value, with: T.NumberTextGraph.Currency.init)
    }
        
    func XCTAssertDefaultPrecisionLimits(_ limits: ClosedRange<Int>, code: String) {
        typealias Style = NumberTextStyle<Decimal>.Currency
        let cache = Style(code: code, locale: .en_US_POSIX).cache()
        XCTAssertEqual(cache.precision.integer,  1 ... Decimal._NumberTextGraph.precision)
        XCTAssertEqual(cache.precision.fraction, limits)
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
        XCTAssertDefaultPrecisionLimits(0...0, code: "JPY")
        XCTAssertDefaultPrecisionLimits(2...2, code: "USD")
        XCTAssertDefaultPrecisionLimits(3...3, code: "BHD")
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
    
    func testFloat64_aka_Double() throws {
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

    func testInt() throws {
        XCTAssertCurrencies(-123 as Int)
    }
    
    func testInt8() throws {
        XCTAssertCurrencies(-123 as Int8)
    }
    
    func testInt16() throws {
        XCTAssertCurrencies(-123 as Int16)
    }
    
    func testInt32() throws {
        XCTAssertCurrencies(-123 as Int32)
    }
    
    func testInt64() throws {
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
    
    func testUInt() throws {
        XCTAssertCurrencies(123 as UInt)
    }
    
    func testUInt8() throws {
        XCTAssertCurrencies(123 as UInt8)
    }
    
    func testUInt16() throws {
        XCTAssertCurrencies(123 as UInt16)
    }
    
    func testUInt32() throws {
        XCTAssertCurrencies(123 as UInt32)
    }
    
    func testUInt64() throws {
        XCTAssertCurrencies(123 as UInt64)
    }
}

#endif
