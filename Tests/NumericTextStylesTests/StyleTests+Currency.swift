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
final class CurrencyTests: StyleTests {
    
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
        XCTInterpretLocalesXCurrencies(-1.23 as Float64)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests - Inaccurate
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(-1.23 as Float16, result: "-$1.23046875")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(-1.23 as Float32, result: "-$1.2300000190734863")
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

extension CurrencyTests {
    
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
