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
// MARK: * StyleTests x Number
//*============================================================================*

final class NumberTests: XCTestCase, StyleTests {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTInterpretLocales<T: Value.Number>(_ value: T) {
         XCTInterpretLocales(value, format: T.Number.init)
    }
    
    func XCTAssert<T: Value.Number>(_ value: T, result: String) {
         XCTAssert(value, format: T.Number(locale: en_US), result: result)
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
        XCTInterpretLocales(Int("-123")!)
    }
    
    func testInt8() throws {
        XCTInterpretLocales(Int8("-123")!)
    }
    
    func testInt16() throws {
        XCTInterpretLocales(Int16("-123")!)
    }
    
    func testInt32() throws {
        XCTInterpretLocales(Int32("-123")!)
    }
    
    func testInt64() throws {
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
        XCTInterpretLocales(UInt("123")!)
    }
    
    func testUInt8() throws {
        XCTInterpretLocales(UInt8("123")!)
    }
    
    func testUInt16() throws {
        XCTInterpretLocales(UInt16("123")!)
    }
    
    func testUInt32() throws {
        XCTInterpretLocales(UInt32("123")!)
    }
    
    func testUInt64() throws {
        XCTInterpretLocales(UInt64("123")!)
    }
}
#endif
