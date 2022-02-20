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
// MARK: * FormatTests x Number
//*============================================================================*

final class NumberTests: XCTestCase, FormatTests {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let tests = Set(Test.allCases)
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    /// Iterates about 1k times.
    func XCTInterpretLocales<T: Value.Number>(_ value: T) {
        XCTInterpretLocales(value, format: T.Number.init)
    }
    
    func XCTAssert<T: Value.Number>(_ value: T, result: String) {
         XCTAssert(value, format: T.Number(locale: en_US), result: result)
    }
    
    //*========================================================================*
    // MARK: * Test
    //*========================================================================*
    
    enum Test: CaseIterable {
        case decimal
        case float64
        case  int,  int8,   int16,   int32,   int64
        case uint, uint8,  uint16,  uint32,  uint64
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension NumberTests {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() throws {
        try XCTSkipUnless(tests.contains(.decimal))
        XCTInterpretLocales(Decimal(string: "-1.23")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension NumberTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testFloat64() throws {
        try XCTSkipUnless(tests.contains(.float64))
        XCTInterpretLocales(Float64("-1.23")!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Inaccurate
    //=------------------------------------------------------------------------=
    
    func testFloat16IsInaccurate() {
        XCTAssert(Float16("1.23")!, result: "1.23046875")
    }
    
    func testFloat32IsInaccurate() {
        XCTAssert(Float32("1.23")!, result: "1.2300000190734863")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension NumberTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() throws {
        try XCTSkipUnless(tests.contains(.int))
        XCTInterpretLocales(Int("-123")!)
    }
    
    func testInt8() throws {
        try XCTSkipUnless(tests.contains(.int8))
        XCTInterpretLocales(Int8("-123")!)
    }
    
    func testInt16() throws {
        try XCTSkipUnless(tests.contains(.int16))
        XCTInterpretLocales(Int16("-123")!)
    }
    
    func testInt32() throws {
        try XCTSkipUnless(tests.contains(.int32))
        XCTInterpretLocales(Int32("-123")!)
    }
    
    func testInt64() throws {
        try XCTSkipUnless(tests.contains(.int64))
        XCTInterpretLocales(Int64("-123")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension NumberTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() throws {
        try XCTSkipUnless(tests.contains(.uint))
        XCTInterpretLocales(UInt("123")!)
    }
    
    func testUInt8() throws {
        try XCTSkipUnless(tests.contains(.uint8))
        XCTInterpretLocales(UInt8("123")!)
    }
    
    func testUInt16() throws {
        try XCTSkipUnless(tests.contains(.uint16))
        XCTInterpretLocales(UInt16("123")!)
    }
    
    func testUInt32() throws {
        try XCTSkipUnless(tests.contains(.uint32))
        XCTInterpretLocales(UInt32("123")!)
    }
    
    func testUInt64() throws {
        try XCTSkipUnless(tests.contains(.uint64))
        XCTInterpretLocales(UInt64("123")!)
    }
}
#endif
