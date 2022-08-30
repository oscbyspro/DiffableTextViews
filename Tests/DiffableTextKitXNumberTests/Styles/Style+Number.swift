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
// MARK: * Style x Tests x Number
//*============================================================================*

final class StyleTestsOnNumber: StyleTests {

    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertLocales<T: _Value>(_ value: T) where T.NumberTextGraph: _Numberable {
        for locale in locales {
            XCTAssert(value, with: T.NumberTextGraph.Number(locale: locale))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension StyleTestsOnNumber {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecimal() {
        XCTAssertLocales(Decimal(string: "-1234567.89")!)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floats
//=----------------------------------------------------------------------------=

extension StyleTestsOnNumber {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testFloat64_aka_Double() {
        XCTAssertLocales(-1.23 as Float64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Ints
//=----------------------------------------------------------------------------=

extension StyleTestsOnNumber {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testInt() {
        XCTAssertLocales(-123 as Int)
    }
    
    func testInt8() {
        XCTAssertLocales(-12_ as Int8) // 9s
    }
    
    func testInt16() {
        XCTAssertLocales(-123 as Int16)
    }
    
    func testInt32() {
        XCTAssertLocales(-123 as Int32)
    }
    
    func testInt64() {
        XCTAssertLocales(-123 as Int64)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UInts
//=----------------------------------------------------------------------------=

extension StyleTestsOnNumber {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt() {
        XCTAssertLocales(123 as UInt)
    }
    
    func testUInt8() {
        XCTAssertLocales(12_ as UInt8) // 9s
    }
    
    func testUInt16() {
        XCTAssertLocales(123 as UInt16)
    }
    
    func testUInt32() {
        XCTAssertLocales(123 as UInt32)
    }
    
    func testUInt64() {
        XCTAssertLocales(123 as UInt64)
    }
}

#endif
