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
// MARK: * StyleTests x Currency
//*============================================================================*

/// - About 100 MB will be allocated per type that is tested.
/// - There are about 144k locale-currency pairs, so it may take some time.
final class CurrencyTests: XCTestCase, StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocalesXCurrencies<T: Value.Currency>(_ value: T) {
         XCTInterpretLocalesXCurrencies(value, format: T.Currency.init)
    }

    func XCTAssert<T: Value.Currency>(_ value: T, result: String) {
         XCTAssert(value, format: T.Currency(code: USD, locale: en_US), result: result)        
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension CurrencyTests {

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

extension CurrencyTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFloat64() throws {
        XCTInterpretLocalesXCurrencies(Float64("-1.23")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Inaccurate
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(Float16("1.23")!, result: "$1.23046875")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(Float32("1.23")!, result: "$1.2300000190734863")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension CurrencyTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() throws {
        XCTInterpretLocalesXCurrencies(Int("-123")!)
    }
    
    func testInt8() throws {
        XCTInterpretLocalesXCurrencies(Int8("-123")!)
    }
    
    func testInt16() throws {
        XCTInterpretLocalesXCurrencies(Int16("-123")!)
    }
    
    func testInt32() throws {
        XCTInterpretLocalesXCurrencies(Int32("-123")!)
    }
    
    func testInt64() throws {
        XCTInterpretLocalesXCurrencies(Int64("-123")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension CurrencyTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() throws {
        XCTInterpretLocalesXCurrencies(UInt("123")!)
    }
    
    func testUInt8() throws {
        XCTInterpretLocalesXCurrencies(UInt8("123")!)
    }
    
    func testUInt16() throws {
        XCTInterpretLocalesXCurrencies(UInt16("123")!)
    }
    
    func testUInt32() throws {
        XCTInterpretLocalesXCurrencies(UInt32("123")!)
    }
    
    func testUInt64() throws {
        XCTInterpretLocalesXCurrencies(UInt64("123")!)
    }
}

#endif
