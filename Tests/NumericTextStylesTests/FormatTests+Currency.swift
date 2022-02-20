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

#warning("DRY")
//*============================================================================*
// MARK: * FormatTests x Currency
//*============================================================================*

/// - There are many 144k locale-currency pairs, so it will take some time.
/// - Apple's format style cache will allocate ~100 MB per type that is tested.
final class CurrencyTests: XCTestCase, FormatTests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let tests = Set([Test.decimal])
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocalesXCurrencies<T: Value.Currency>(_ value: T) {
         XCTInterpretLocalesXCurrencies(value, format: T.Currency.init)
    }

    //*========================================================================*
    // MARK: * Test
    //*========================================================================*
    
    enum Test: CaseIterable {
        case decimal
        case float,        float16, float32, float64
        case   int,  int8,   int16,   int32,   int64
        case  uint, uint8,  uint16,  uint32,  uint64
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
        try XCTSkipUnless(tests.contains(.decimal))
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

    func testFloat() throws {
        try XCTSkipUnless(tests.contains(.float))
        XCTInterpretLocalesXCurrencies(Float("-1.23")!)
    }
    
    func testFloat16() throws {
        try XCTSkipUnless(tests.contains(.float16))
        XCTInterpretLocalesXCurrencies(Float16("-1.23")!)
    }
    
    func testFloat32() throws {
        try XCTSkipUnless(tests.contains(.float32))
        XCTInterpretLocalesXCurrencies(Float32("-1.23")!)
    }
    
    func testFloat64() throws {
        try XCTSkipUnless(tests.contains(.float64))
        XCTInterpretLocalesXCurrencies(Float64("-1.23")!)
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
        try XCTSkipUnless(tests.contains(.int))
        XCTInterpretLocalesXCurrencies(Int("-123")!)
    }
    
    func testInt8() throws {
        try XCTSkipUnless(tests.contains(.int8))
        XCTInterpretLocalesXCurrencies(Int8("-123")!)
    }
    
    func testInt16() throws {
        try XCTSkipUnless(tests.contains(.int16))
        XCTInterpretLocalesXCurrencies(Int16("-123")!)
    }
    
    func testInt32() throws {
        try XCTSkipUnless(tests.contains(.int32))
        XCTInterpretLocalesXCurrencies(Int32("-123")!)
    }
    
    func testInt64() throws {
        try XCTSkipUnless(tests.contains(.int64))
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
        try XCTSkipUnless(tests.contains(.uint))
        XCTInterpretLocalesXCurrencies(UInt("123")!)
    }
    
    func testUInt8() throws {
        try XCTSkipUnless(tests.contains(.uint8))
        XCTInterpretLocalesXCurrencies(UInt8("123")!)
    }
    
    func testUInt16() throws {
        try XCTSkipUnless(tests.contains(.uint16))
        XCTInterpretLocalesXCurrencies(UInt16("123")!)
    }
    
    func testUInt32() throws {
        try XCTSkipUnless(tests.contains(.uint32))
        XCTInterpretLocalesXCurrencies(UInt32("123")!)
    }
    
    func testUInt64() throws {
        try XCTSkipUnless(tests.contains(.uint64))
        XCTInterpretLocalesXCurrencies(UInt64("123")!)
    }
}

#endif
